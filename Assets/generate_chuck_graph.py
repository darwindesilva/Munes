#!/usr/bin/env python3
# makes the chord graph block for munes_music.ck
#
# python generate_chuck_graph.py
#     prints the block so you can paste it into the ck file
#
# python generate_chuck_graph.py --ck munes_music.ck --info Assets/Resources/chord_info.txt
#     patches the block inside the ck file and writes the chord table unity reads
#
# node format: "name|chord;chord|next,next|bass;bass"
#   ';' splits chords inside one node (the music steps through them on each jump)
#   ',' splits the notes in a chord, keep them low to high so the slides stay short
#   'x' is a silent slot
#   one bass value is used for every chord in the node
#
# every node has to sit on its own line, the line number shows up in the unity overlay

import argparse
import os
import re
import sys

GRAPHS = {
    # my own progression
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

    "hinge_to_Am": [
        "Cmaj7|C3,E3,G3,B3|Em7|C2",
        "Em7|E3,G3,B3,D4|Am7|E2",
        "Am7|A2,C3,E3,G3|E7|A1",
        "E7|E2,G#2,B2,D3|Am|E2",
        "Am|A2,C3,E3|Em7,Cmaj7|A1",
    ],

    # dark cinematic c minor, the bVI and bVII moves and a few chromatic mediants
    "dean_minor": [
        "Cm9|C3,Eb3,G3,Bb3,D4,G4|Cm11,CmMaj9,Abmaj9,Bbadd9,Fm9|C2",
        "Cm11|C3,Eb3,G3,Bb3,D4,F4|Cm9,Fm9,Ebmaj9,G7sus,Aeolian_walk|C2",
        "CmMaj9|C3,Eb3,G3,B3,D4,G4|Cm9,Abmaj9,Fm9,Bdim7|C2",
        "Abmaj9|C3,Eb3,G3,Bb3,C4,Eb4|Fm9,Ebmaj9,Dbmaj9,Emaj9,Bbadd9|Ab1",
        "Fm9|C3,Eb3,Ab3,C4,Eb4,G4|Cm11,G7sus,Dbmaj9,Bbadd9,Aeolian_walk|F1",
        "Bbadd9|D3,F3,Bb3,C4,D4,F4|G7sus,Cm9,Abmaj9,Gm9|Bb1",
        "Ebmaj9|Eb3,G3,Bb3,D4,F4,Bb4|Abmaj9,Cm9,Bbadd9,Gm9|Eb2",
        "G7sus|D3,G3,C4,D4,F4,Ab4|Cm9,Abmaj9,Ebmaj9,Bdim7|G1",
        "Gm9|D3,F3,Bb3,D4,F4,A4|Cm9,Ebmaj9,Fm9|G1",
        "Dbmaj9|Db3,F3,Ab3,C4,Eb4,G4|Cm9,Fm9,Abmaj9|Db2",
        "Emaj9|E3,G#3,B3,D#4,F#4,B4|Abmaj9,Cm11,Ebmaj9|E2",
        "Bdim7|D3,F3,Ab3,B3,D4,F4|Cm9,Cm11,Abmaj9|B1",
        "Aeolian_walk|Eb3,G3,Bb3,D4,F4,Bb4;D3,F3,Bb3,C4,D4,F4;C3,Eb3,G3,Bb3,D4,G4|Fm9,Abmaj9,G7sus|Eb2;Bb1;C2",
    ],

    # floaty f lydian, major chords with the #11 and big third jumps
    "lydian_haze": [
        "Fmaj9#11|F3,A3,C4,E4,G4,B4|Gadd9,Cmaj9,Bbmaj9#11,Abmaj9,Am9|F2",
        "Gadd9|D3,G3,A3,B3,D4,G4|Fmaj9#11,Cmaj9,Am9,Csus2|G1",
        "Cmaj9|C3,E3,G3,B3,D4,G4|Am9,Dm9,Fmaj9#11,Abmaj9,Emaj9,Chromatic_mediants|C2",
        "Am9|C3,E3,G3,B3,E4,A4|Dm9,Fmaj9#11,Gadd9,Bbmaj9#11|A1",
        "Dm9|C3,E3,A3,C4,F4,A4|Gadd9,Cmaj9,Bbmaj9#11,Fadd9|D2",
        "Bbmaj9#11|D3,F3,A3,C4,E4,A4|Fmaj9#11,Cmaj9,Abmaj9,Gadd9|Bb1",
        "Abmaj9|C3,Eb3,G3,Bb3,C4,Eb4|Cmaj9,Emaj9,Fmaj9#11,Bbmaj9#11|Ab1",
        "Emaj9|E3,G#3,B3,D#4,F#4,B4|Abmaj9,Cmaj9,Am9,Fmaj9#11,Chromatic_mediants|E2",
        "Fadd9|C3,F3,G3,A3,C4,F4|Fmaj9#11,Dm9,Csus2,Lydian_rise|F1",
        "Csus2|C3,D3,G3,C4,D4,G4|Cmaj9,Fmaj9#11,Am9,Gadd9,Lydian_rise|C2",
        "Lydian_rise|C3,F3,G3,A3,C4,F4;D3,G3,A3,B3,D4,G4;C3,E3,G3,B3,E4,A4|Cmaj9,Bbmaj9#11|F1;G1;A1",
        "Chromatic_mediants|C3,E3,G3,B3,D4,G4;C3,Eb3,G3,Bb3,C4,Eb4;E3,G#3,B3,D#4,F#4,B4|Fmaj9#11,Am9|C2;Ab1;E2",
    ],

    # d dorian, sus chords and a lot of d in the bass
    "dorian_haze": [
        "Dm11|D3,F3,A3,C4,E4,G4|Dm9,G13,Em7b9,Bbmaj9#11,Dorian_float|D2",
        "Dm9|D3,F3,A3,C4,E4,A4|Dm11,Fmaj9#11,Gsus9,Am11,Dsus2|D2",
        "Bbmaj9#11|D3,F3,A3,C4,E4,A4|Dm9,Fmaj9#11,Cmaj9#5,Gsus9|Bb1",
        "Em7b9|E3,G3,B3,D4,F4,A4|Dm11,Fmaj9#11,Bm7b5,Am11,Cadence_tilt|E2",
        "Fmaj9#11|F3,A3,C4,E4,G4,B4|G13,Em7b9,Dm9,Cmaj9#5|F2",
        "G13|F3,B3,D4,E4,G4,A4|Dm11,Am11,Fmaj9#11,Gsus9|G1",
        "Gsus9|D3,G3,C4,D4,F4,A4|G13,Dm11,Am11,Bbmaj9#11|G1",
        "Am11|C3,E3,G3,B3,D4,G4|Dm9,Fmaj9#11,Em7b9,Bm7b5|A1",
        "Bm7b5|D3,F3,A3,B3,D4,F4|Em7b9,Dm11,Am11,Cadence_tilt|B1",
        "Cmaj9#5|C3,E3,G#3,B3,D4,F#4|Dm9,Fmaj9#11,Bbmaj9#11|C2",
        "Dsus2|D3,A3,D4,E4,G4,A4|Dm11,Dm9,Dorian_float|D2",
        "Dorian_float|D3,F3,A3,C4,E4,A4;E3,G3,B3,D4,F4,A4;F3,A3,C4,E4,G4,B4;D3,G3,C4,D4,F4,A4|Dm11,Gsus9,Am11|D2",
        "Cadence_tilt|D3,F3,A3,B3,D4,F4;E3,G3,B3,D4,F4,A4;C3,E3,G3,B3,D4,G4|Dm11,Dm9,Fmaj9#11|B1;E2;A1",
    ],
}

# unity zone number % number of graphs picks the graph, so keep this the same length as zoneCount
ORDER = ["dar", "jazz", "hinge_to_Am", "dean_minor", "lydian_haze", "dorian_haze"]

START_MARK = "// generated block start"
END_MARK = "// generated block end"


def note_to_midi(note):
    note = note.strip()
    if note in ("x", "X", "-", ""):
        return -1
    m = re.match(r'^([A-Ga-g])([#b]?)(-?\d+)$', note)
    if not m:
        raise ValueError("bad note name: " + repr(note))
    letter, accidental, octave = m.group(1).upper(), m.group(2), int(m.group(3))
    semitone = {'C': 0, 'D': 2, 'E': 4, 'F': 5, 'G': 7, 'A': 9, 'B': 11}[letter]
    if accidental == '#':
        semitone += 1
    elif accidental == 'b':
        semitone -= 1
    return semitone + (octave + 1) * 12


def parse_node(text):
    parts = text.strip().split('|')
    if len(parts) != 4:
        raise ValueError("node needs 4 fields: " + repr(text))
    name, chords_str, succ_str, bass_str = [p.strip() for p in parts]

    chords = []
    for chunk in chords_str.split(';'):
        if chunk.strip():
            chords.append([n.strip() for n in chunk.split(',')])
    if not chords:
        raise ValueError("node " + name + " has no chords")

    if not bass_str:
        bass = ["-"] * len(chords)
    else:
        bass = [b.strip() for b in bass_str.split(';')]
        if len(bass) == 1:
            bass = bass * len(chords)
        elif len(bass) != len(chords):
            raise ValueError("node " + name + ": bass count doesn't match chord count")

    succ = [s.strip() for s in succ_str.split(',') if s.strip()]
    return name, chords, succ, bass


def find_line(lines, graph_name, node_text):
    start = 0
    for i, line in enumerate(lines):
        if re.match(r'\s*"' + re.escape(graph_name) + r'"\s*:\s*\[', line):
            start = i
            break
    for i in range(start, len(lines)):
        if '"' + node_text + '"' in lines[i]:
            return i + 1
    return 0


def build(graphs, order):
    with open(os.path.abspath(__file__), encoding="utf-8") as f:
        src_lines = f.read().split("\n")

    chords_out = []        # midi notes per chord
    bass_out = []
    chord_names = []       # node name per chord, for the comments
    node_chord_off = []
    node_chord_cnt = []
    succ_off = []
    succ_cnt = []
    succ_tgt = []
    graph_off = []
    graph_cnt = []
    info = []

    for gname in order:
        raw_nodes = graphs[gname]
        parsed = [parse_node(s) for s in raw_nodes]
        name_to_local = {}
        for i, p in enumerate(parsed):
            if p[0] in name_to_local:
                raise ValueError("graph " + gname + " has two nodes called " + p[0])
            name_to_local[p[0]] = i

        for name, _, succ, _ in parsed:
            for s in succ:
                if s not in name_to_local:
                    raise ValueError("graph " + gname + ", node " + name + ": no node called " + s)

        base = len(node_chord_off)
        graph_off.append(base)
        graph_cnt.append(len(parsed))

        for raw, (name, chords, succ, bass) in zip(raw_nodes, parsed):
            line_no = find_line(src_lines, gname, raw)
            node_chord_off.append(len(chords_out))
            node_chord_cnt.append(len(chords))

            for pos, notes in enumerate(chords):
                midi = [note_to_midi(n) for n in notes]
                chords_out.append(midi)
                bass_out.append(note_to_midi(bass[pos]))
                chord_names.append(name)
                shown = " ".join(n for n in notes if note_to_midi(n) >= 0)
                midi_txt = " ".join(str(m) for m in midi if m >= 0)
                info.append("|".join([
                    str(len(chords_out) - 1), gname, name, str(pos + 1),
                    str(len(chords)), str(line_no), shown, midi_txt, bass[pos],
                ]))

            succ_off.append(len(succ_tgt))
            succ_cnt.append(len(succ))
            for s in succ:
                succ_tgt.append(base + name_to_local[s])

    per_chord = max(len(c) for c in chords_out)

    def nums(values):
        return ", ".join(str(v) for v in values)

    out = []
    out.append("// made by generate_chuck_graph.py, change the python file instead of this block")
    out.append("// graph order: " + ", ".join(order))
    out.append("")
    out.append(str(per_chord) + " => int NOTES_PER_CHORD;")
    out.append(str(len(node_chord_off)) + " => int NODE_COUNT;")
    out.append(str(len(chords_out)) + " => int CHORD_COUNT;")
    out.append(str(len(order)) + " => int NUM_GRAPHS;")
    out.append("")
    out.append("[" + nums(graph_off) + "] @=> int GRAPH_NODE_OFFSETS[];")
    out.append("[" + nums(graph_cnt) + "] @=> int GRAPH_NODE_COUNTS[];")
    out.append("")
    out.append("[")
    for i, c in enumerate(chords_out):
        padded = c + [-1] * (per_chord - len(c))
        row = ", ".join("%3d" % m for m in padded)
        out.append("  %s,  // %d %s" % (row, i, chord_names[i]))
    out.append("] @=> int CHORDS[];")
    out.append("")
    out.append("[" + nums(bass_out) + "] @=> int BASS_NOTES[];")
    out.append("")
    out.append("[" + nums(node_chord_off) + "] @=> int NODE_CHORD_OFFSETS[];")
    out.append("[" + nums(node_chord_cnt) + "] @=> int NODE_CHORD_COUNTS[];")
    out.append("")
    out.append("[" + nums(succ_off) + "] @=> int SUCC_OFFSETS[];")
    out.append("[" + nums(succ_cnt) + "] @=> int SUCC_COUNTS[];")
    out.append("[" + nums(succ_tgt) + "] @=> int SUCC_TARGETS[];")
    return "\n".join(out), "\n".join(info) + "\n"


def patch_ck(path, block):
    with open(path, newline="") as f:
        text = f.read()
    newline = "\r\n" if "\r\n" in text else "\n"
    text = text.replace("\r\n", "\n")

    a = text.find(START_MARK)
    b = text.find(END_MARK)
    if a < 0 or b < 0:
        sys.exit("couldn't find the start and end markers in " + path)
    a_end = text.index("\n", a) + 1

    text = text[:a_end] + "\n" + block + "\n\n" + text[b:]
    with open(path, "w", newline="") as f:
        f.write(text.replace("\n", newline))


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--ck", help="ck file to patch")
    ap.add_argument("--info", help="where to write the chord table for unity")
    args = ap.parse_args()

    block, info = build(GRAPHS, ORDER)

    if args.ck:
        patch_ck(args.ck, block)
        print("patched " + args.ck)
    else:
        print(block)

    if args.info:
        with open(args.info, "w", newline="") as f:
            f.write(info)
        print("wrote " + args.info)