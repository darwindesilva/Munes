#!/usr/bin/env python3
"""
ChucK chord graph generator for Munes.

Node format (one string per node):
    "name|chord1;chord2;...|succ1,succ2|bass1;bass2;..."

- ';' inside the chord field separates multiple chords in the node.
- ',' inside a chord separates note channels.
- 'x' means "empty channel" — fades in/out without sliding from anywhere.
- '-' or empty means the same as 'x'.
- bass uses ';' to give one value per chord. A single value applies
  to all chords in the node.
- successors are node names in the same graph.

Example (2 chords, 4 channels, x is a silent 4th voice):
    "A1|C4,E4,G4,x;D5,B5,F5,A5|Am,Fmaj|C2;B2"
"""

import re

GRAPHS = {
    # ============================================================
    # JAZZ — ii-V-I, secondary dominants, modal interchange
    # ============================================================
    "jazz": [
        "Dm7|D3,F3,A3,C4|G7,Cmaj7|D2",
        "G7|G3,B3,D4,F4|Cmaj7,Dm7|G1",
        "Cmaj7|C3,E3,G3,B3|Am7,Dm7|C2",
        "Am7|A2,C3,E3,G3|D7,Gmaj7|A1",
        "D7|D3,F#3,A3,C4|Gmaj7,Am7|D2",
        "Gmaj7|G2,B2,D3,F#3|Cmaj7,Am7|G1",
        "Fmaj7|F3,A3,C4,E4|G7,Em7|F1",
        "Em7|E3,G3,B3,D4|Am7,Dm7|E2",
    ],

    # ============================================================
    # HINGE TO G — C major ⇄ G major via Am7 pivot
    # ============================================================
    "hinge_to_G": [
        "C|C3,E3,G3,B3|Am7|C2",
        "Am7|A2,C3,E3,G3|D7|A1",
        "D7|D3,F#3,A3,C4|Gmaj7|D2",
        "Gmaj7|G2,B2,D3,F#3;E3,G3,B3,D4|Em7|G1;E2",
        "Em7|E3,G3,B3,D4|Am7,D7|E2",
    ],

    # ============================================================
    # HINGE TO F — C major ⇄ F major via Dm7 pivot
    # ============================================================
    "hinge_to_F": [
        "C|C3,E3,G3,B3|Dm7|C2",
        "Dm7|D3,F3,A3,C4|C7|D2",
        "C7|C3,E3,G3,Bb3|Fmaj7|C2",
        "Fmaj7|F3,A3,C4,E4;G2,Bb2,D3,F3|Gm7|F1;G1",
        "Gm7|G2,Bb2,D3,F3|C7|G1",
    ],

    # ============================================================
    # HINGE TO Am — C major ⇄ A minor via Em7 pivot
    # ============================================================
    "hinge_to_Am": [
        "C|C3,E3,G3,B3|Em7|C2",
        "Em7|E3,G3,B3,D4|Am7|E2",
        "Am7|A2,C3,E3,G3|E7|A1",
        "E7|E2,G#2,B2,D3|Am|E2",
        "Am|A2,C3,E3|Em7,C|A1",
    ],

    "darwin1": [
        "A1|C3,E3,G3,B3,x;C3,E3,G3,B3,D3|A2|C2",
        "A2|D3,F3,A3,C3,x;D3,F3,A3,C3,E4;|A3|D2;D2",
        "A3|C3,G3,E4,x,x|A1|C2",

    ],
}

ACTIVE_GRAPH = "darwin1"   # switch to "hinge_to_G", "hinge_to_F", "hinge_to_Am"


def note_to_midi(note):
    note = note.strip()
    if note in ("x", "X", "-", ""):
        return -1
    m = re.match(r'^([A-Ga-g])([#b]?)(-?\d+)$', note)
    if not m:
        raise ValueError(f"Bad note name: {note!r}")
    letter, accidental, octave = m.group(1).upper(), m.group(2), int(m.group(3))
    semitone = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}[letter]
    if accidental == '#':
        semitone += 1
    elif accidental == 'b':
        semitone -= 1
    return semitone + (octave + 1) * 12


def parse_node(s):
    s = s.strip()
    if s.startswith('"') and s.endswith('"'):
        s = s[1:-1]
    parts = s.split('|')
    if len(parts) != 4:
        raise ValueError(f"Node must have 4 '|' fields, got {len(parts)}: {s!r}")

    name, chords_str, succ_str, bass_str = [p.strip() for p in parts]

    chords = []
    if chords_str:
        for chord_text in chords_str.split(';'):
            chord_text = chord_text.strip()
            if chord_text:
                notes = [n.strip() for n in chord_text.split(',')]
                chords.append(notes)

    if not chords:
        raise ValueError(f"Node {name!r} has no chords")

    n_chords = len(chords)

    if not bass_str:
        bass_vals = ["-"] * n_chords
    else:
        vals = [v.strip() for v in bass_str.split(';')]
        if len(vals) == 1:
            bass_vals = vals * n_chords
        elif len(vals) == n_chords:
            bass_vals = vals
        else:
            raise ValueError(
                f"Node {name!r}: bass has {len(vals)} values but {n_chords} chords")

    successors = [x.strip() for x in succ_str.split(',') if x.strip()] if succ_str else []

    return name, chords, successors, bass_vals


def emit_graph(node_strings, graph_name):
    parsed = [parse_node(s) for s in node_strings]
    names = [p[0] for p in parsed]
    name_to_idx = {n: i for i, n in enumerate(names)}

    for name, _, succ, _ in parsed:
        for s in succ:
            if s not in name_to_idx:
                raise ValueError(f"Node '{name}' lists unknown successor '{s}'")

    chord_list = []
    chord_bass = []
    node_chord_offsets = []
    node_chord_counts = []

    for name, chords, _, bass_vals in parsed:
        node_chord_offsets.append(len(chord_list))
        node_chord_counts.append(len(chords))
        for i, notes in enumerate(chords):
            midis = [note_to_midi(n) for n in notes]
            chord_list.append(midis)
            chord_bass.append(note_to_midi(bass_vals[i]))

    if not chord_list:
        raise ValueError("No chords defined")

    notes_per_chord = max(len(c) for c in chord_list)
    n_nodes = len(parsed)
    n_chords = len(chord_list)

    chords_flat = []
    for c in chord_list:
        padded = c + [-1] * (notes_per_chord - len(c))
        chords_flat.extend(padded)

    succ_offsets, succ_counts, succ_targets = [], [], []
    offset = 0
    for name, _, succ, _ in parsed:
        succ_offsets.append(offset)
        succ_counts.append(len(succ))
        for s in succ:
            succ_targets.append(name_to_idx[s])
        offset += len(succ)

    print("// ============================================================")
    print(f"// AUTO-GENERATED by generate_chuck_graph.py — graph: '{graph_name}'")
    print("// ============================================================")
    print()
    print(f"{notes_per_chord} => int NOTES_PER_CHORD;")
    print(f"{n_nodes} => int NODE_COUNT;")
    print(f"{n_chords} => int CHORD_COUNT;")
    print()

    print(f"// Graph: '{graph_name}'")
    for i, (name, chords, succ, _) in enumerate(parsed):
        chain = " -> ".join("[" + ",".join(c) + "]" for c in chords)
        s = ", ".join(succ) if succ else "(none)"
        print(f"//   {i:2d}  {name:10s}  {chain}  → {s}")
    print()

    print("[")
    for i, c in enumerate(chord_list):
        padded = c + [-1] * (notes_per_chord - len(c))
        line = ", ".join(f"{m:3d}" for m in padded)
        print(f"  {line},  // {i:2d}")
    print("] @=> int CHORDS[];")
    print()

    print(f"[{', '.join(f'{m:3d}' for m in chord_bass)}] @=> int BASS_NOTES[];")
    print()

    print(f"[{', '.join(str(x) for x in node_chord_offsets)}] @=> int NODE_CHORD_OFFSETS[];")
    print(f"[{', '.join(str(x) for x in node_chord_counts)}] @=> int NODE_CHORD_COUNTS[];")
    print()

    print(f"[{', '.join(str(x) for x in succ_offsets)}] @=> int SUCC_OFFSETS[];")
    print(f"[{', '.join(str(x) for x in succ_counts)}] @=> int SUCC_COUNTS[];")
    print(f"[{', '.join(str(x) for x in succ_targets)}] @=> int SUCC_TARGETS[];")


if __name__ == "__main__":
    emit_graph(GRAPHS[ACTIVE_GRAPH], ACTIVE_GRAPH)