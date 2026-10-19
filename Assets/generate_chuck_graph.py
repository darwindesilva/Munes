#!/usr/bin/env python3
"""
ChucK chord graph generator for Munes — multi-graph version.

All graphs are concatenated into one block. ChucK switches between
graphs based on in_zone (mapped via in_zone % NUM_GRAPHS).

Node format:
    "name|chord1;chord2;...|succ1,succ2|bass1;bass2;..."

- ';' inside the chord field separates chords within the node.
- ',' inside a chord separates note channels.
- 'x' / '-' / empty = silent channel (snaps+fades when populated).
- bass uses ';' per-chord; single value applies to all chords.

The "dar" graph from earlier is preserved as graph 0.
"""

import re

GRAPHS = {
    # ============================================================
    # dar — user's preserved custom progression
    # ============================================================
    "dar": [
        "A1|C3,E3,G3,B3,x;C3,E3,G3,B3,D3|A2|C2;C2",
        "A2|D3,F3,A3,C3,x;D3,F3,A3,C3,E4|A3|D2;D2",
        "A3|C3,G3,E4,x,x;C3,G3,B3,x,x|A4|G2;G2",
        "A4|C3,E3,G3,A3,x|A5|C2",
        "A5|D3,F3,A3,C4,x|A1|D2",
    ],


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
}

ACTIVE_GRAPHS_ORDER = ["dar", "jazz", "hinge_to_Am"]
# ^ The order in which graphs are emitted. ChucK maps in_zone to a graph
#   via in_zone % NUM_GRAPHS. If zoneCount in Unity matches this list
#   length, zones are 1:1 with graphs.


def note_to_midi(note):
    note = note.strip()
    if note in ("x", "X", "-", ""):
        return -1
    m = re.match(r'^([A-Ga-g])([#b]?)(-?\d+)$', note)
    if not m:
        raise ValueError(f"Bad note name: {note!r}")
    letter, accidental, octave = m.group(1).upper(), m.group(2), int(m.group(3))
    semitone = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}[letter]
    if accidental == '#': semitone += 1
    elif accidental == 'b': semitone -= 1
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
                chords.append([n.strip() for n in chord_text.split(',')])

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
            raise ValueError(f"Node {name!r}: bass has {len(vals)} values but {n_chords} chords")

    successors = [x.strip() for x in succ_str.split(',') if x.strip()] if succ_str else []
    return name, chords, successors, bass_vals


def emit_all(graphs, order):
    # Global counters
    global_chords = []          # list of [midi...]
    global_bass = []            # midi per chord
    global_node_chord_off = []  # GLOBAL start chord index per GLOBAL node
    global_node_chord_cnt = []  # chord count per node
    global_succ_off = []
    global_succ_cnt = []
    global_succ_tgt = []        # GLOBAL node indices

    graph_node_offsets = []     # start global-node-index per graph
    graph_node_counts = []      # node count per graph

    for gname in order:
        nodes = graphs[gname]
        parsed = [parse_node(s) for s in nodes]
        names_local = [p[0] for p in parsed]
        name_to_local = {n: i for i, n in enumerate(names_local)}

        for name, _, succ, _ in parsed:
            for s in succ:
                if s not in name_to_local:
                    raise ValueError(f"Graph '{gname}' node '{name}' has unknown successor '{s}'")

        graph_node_offsets.append(len(global_node_chord_off))
        graph_node_counts.append(len(parsed))

        # Compute the graph's global node base
        node_base = len(global_node_chord_off)

        for name, chords, succ, bass_vals in parsed:
            global_node_chord_off.append(len(global_chords))
            global_node_chord_cnt.append(len(chords))
            for i, notes in enumerate(chords):
                global_chords.append([note_to_midi(n) for n in notes])
                global_bass.append(note_to_midi(bass_vals[i]))

            global_succ_off.append(len(global_succ_tgt))
            global_succ_cnt.append(len(succ))
            for s in succ:
                global_succ_tgt.append(node_base + name_to_local[s])

    notes_per_chord = max(len(c) for c in global_chords)
    n_nodes = len(global_node_chord_off)
    n_chords = len(global_chords)
    n_graphs = len(order)

    # ---- Emit ----
    print("// ============================================================")
    print(f"// AUTO-GENERATED by generate_chuck_graph.py — multi-graph")
    print(f"// Graph order: {', '.join(order)}")
    print(f"// NUM_GRAPHS = {n_graphs}")
    print("// ============================================================")
    print()
    print(f"{notes_per_chord} => int NOTES_PER_CHORD;")
    print(f"{n_nodes} => int NODE_COUNT;")
    print(f"{n_chords} => int CHORD_COUNT;")
    print(f"{n_graphs} => int NUM_GRAPHS;")
    print()

    # Graph node ranges
    print("// Graph → [start global node, count]")
    print(f"[{', '.join(str(x) for x in graph_node_offsets)}] @=> int GRAPH_NODE_OFFSETS[];")
    print(f"[{', '.join(str(x) for x in graph_node_counts)}]  @=> int GRAPH_NODE_COUNTS[];")
    print()

    # Chords
    print("// All chords (global indices)")
    print("[")
    for i, c in enumerate(global_chords):
        padded = c + [-1] * (notes_per_chord - len(c))
        line = ", ".join(f"{m:3d}" for m in padded)
        print(f"  {line},  // {i:2d}")
    print("] @=> int CHORDS[];")
    print()

    # Bass
    print(f"[{', '.join(f'{m:3d}' for m in global_bass)}] @=> int BASS_NOTES[];")
    print()

    # Per-node chord offsets/counts
    print(f"[{', '.join(str(x) for x in global_node_chord_off)}] @=> int NODE_CHORD_OFFSETS[];")
    print(f"[{', '.join(str(x) for x in global_node_chord_cnt)}] @=> int NODE_CHORD_COUNTS[];")
    print()

    # Successors
    print(f"[{', '.join(str(x) for x in global_succ_off)}] @=> int SUCC_OFFSETS[];")
    print(f"[{', '.join(str(x) for x in global_succ_cnt)}] @=> int SUCC_COUNTS[];")
    print(f"[{', '.join(str(x) for x in global_succ_tgt)}] @=> int SUCC_TARGETS[];")
    print()
    print("// Human-readable summary:")
    for gi, gname in enumerate(order):
        print(f"//   graph[{gi}] = '{gname}'  ({graph_node_counts[gi]} nodes, "
              f"starting at global node {graph_node_offsets[gi]})")


if __name__ == "__main__":
    emit_all(GRAPHS, ACTIVE_GRAPHS_ORDER)