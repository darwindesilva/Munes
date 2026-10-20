#!/usr/bin/env python3
"""
ChucK chord generator — 25 progressions (5 families × 5 keys).
Each progression's exit node leads to N1 of any OTHER progression,
chosen uniformly. No self-cycling.

Families and keys:
  dar   (Cmaj9 → Dm9 → C/G → Am7 → Dm7)         C D Eb F G
  dar2  (Dm9 → G9 → Cmaj9 → Am9 → Dm7)          C D Eb F G
  dar3  (Am9 → Fmaj9 → Em9 → Gsus/G → Am7)      Am Bm Cm Dm Em
  dar4  (Em11 → Am9 → Dm9 → Gsus/G7 → Em7)      Em Fsm Gm Am Bm
  dar5  (Fmaj9 → Gm9 → Cmaj9/E → Fmaj9 → Am7)   F G Ab Bb C
"""

import re

BASE = {
    "dar": [
        ([[48,52,55,59,-1], [48,52,55,59,50]], [36, 36]),
        ([[50,53,57,48,-1], [50,53,57,48,64]], [38, 38]),
        ([[48,55,64,-1,-1], [48,55,59,-1,-1]], [43, 43]),
        ([[48,52,55,57,-1]], [36]),
        ([[50,53,57,60,-1]], [38]),
    ],
    "dar2": [
        ([[50,53,57,60,-1], [50,53,57,60,64]], [38, 38]),
        ([[55,59,62,65,-1], [55,59,62,65,69]], [43, 43]),
        ([[52,55,59,60,-1], [52,55,59,60,62]], [36, 36]),
        ([[57,60,64,67,-1], [57,60,64,67,71]], [33, 33]),
        ([[50,53,57,60,-1]], [38]),
    ],
    "dar3": [
        ([[57,60,64,67,-1], [57,60,64,67,71]], [33, 33]),
        ([[53,57,60,64,-1], [53,57,60,64,67]], [41, 41]),
        ([[52,55,59,60,-1], [52,55,59,60,62]], [36, 36]),
        ([[55,60,62,67,-1], [55,59,62,65,-1]], [43, 43]),
        ([[57,60,64,67,-1]], [33]),
    ],
    "dar4": [
        ([[52,55,59,62,-1], [52,55,59,62,69]], [40, 40]),
        ([[57,60,64,67,-1], [57,60,64,67,71]], [33, 33]),
        ([[50,53,57,60,-1], [50,53,57,60,64]], [38, 38]),
        ([[55,60,62,67,-1], [55,59,62,65,-1]], [43, 43]),
        ([[52,55,59,62,-1]], [40]),
    ],
    "dar5": [
        ([[53,57,60,64,-1], [53,57,60,64,67]], [41, 41]),
        ([[55,58,62,65,-1], [55,58,62,65,69]], [43, 43]),
        ([[52,55,59,60,-1], [52,55,59,60,62]], [36, 36]),
        ([[53,57,60,64,-1], [53,57,60,64,67]], [41, 41]),
        ([[57,60,64,67,-1]], [33]),
    ],
}

FAMILY_KEYS = {
    "dar":  [(0, "C"), (2, "D"), (3, "Eb"), (5, "F"), (7, "G")],
    "dar2": [(0, "C"), (2, "D"), (3, "Eb"), (5, "F"), (7, "G")],
    "dar3": [(0, "Am"), (2, "Bm"), (3, "Cm"), (5, "Dm"), (7, "Em")],
    "dar4": [(0, "Em"), (2, "Fsm"), (3, "Gm"), (5, "Am"), (7, "Bm")],
    "dar5": [(0, "F"), (2, "G"), (3, "Ab"), (5, "Bb"), (7, "C")],
}

FAMILIES = ["dar", "dar2", "dar3", "dar4", "dar5"]


def all_progression_names():
    names = []
    for family in FAMILIES:
        for _, key_label in FAMILY_KEYS[family]:
            names.append(f"{family}_{key_label}")
    return names


def build_all_nodes():
    prog_names = all_progression_names()
    nodes = []

    for family in FAMILIES:
        keys = FAMILY_KEYS[family]
        base = BASE[family]
        n_in_family = len(base)

        for semitones, key_label in keys:
            this_prog = f"{family}_{key_label}"

            # Exit successors: N1 of every OTHER progression, uniform
            exits = [f"{other}_N1" for other in prog_names if other != this_prog]

            for node_idx in range(n_in_family):
                chords_midi, bass_midi = base[node_idx]
                chords_t = [[m + semitones if m >= 0 else -1 for m in c] for c in chords_midi]
                bass_t = [m + semitones if m >= 0 else -1 for m in bass_midi]

                if node_idx < n_in_family - 1:
                    succ = [f"{this_prog}_N{node_idx + 2}"]
                else:
                    succ = exits

                nodes.append({
                    "name": f"{this_prog}_N{node_idx + 1}",
                    "chords": chords_t,
                    "bass": bass_t,
                    "successors": succ,
                })
    return nodes


def main():
    nodes = build_all_nodes()
    name_to_idx = {n["name"]: i for i, n in enumerate(nodes)}

    for n in nodes:
        for s in n["successors"]:
            if s not in name_to_idx:
                raise ValueError(f"Node '{n['name']}' unknown successor '{s}'")

    all_chords, all_bass = [], []
    node_chord_offsets, node_chord_counts = [], []
    succ_offsets, succ_counts, succ_targets = [], [], []

    for n in nodes:
        node_chord_offsets.append(len(all_chords))
        node_chord_counts.append(len(n["chords"]))
        for i, c in enumerate(n["chords"]):
            all_chords.append(c)
            all_bass.append(n["bass"][i])
        succ_offsets.append(len(succ_targets))
        succ_counts.append(len(n["successors"]))
        for s in n["successors"]:
            succ_targets.append(name_to_idx[s])

    notes_per_chord = max(len(c) for c in all_chords)
    n_nodes = len(nodes)
    n_chords = len(all_chords)

    print(f"{notes_per_chord} => int NOTES_PER_CHORD;")
    print(f"{n_nodes} => int NODE_COUNT;")
    print(f"{n_chords} => int CHORD_COUNT;")
    print()
    print("[")
    for c in all_chords:
        padded = c + [-1] * (notes_per_chord - len(c))
        print("   " + ", ".join(f"{m:3d}" for m in padded) + ",")
    print("] @=> int CHORDS[];")
    print()
    print("[" + ", ".join(f"{m:3d}" for m in all_bass) + "] @=> int BASS_NOTES[];")
    print()
    print("[" + ", ".join(map(str, node_chord_offsets)) + "] @=> int NODE_CHORD_OFFSETS[];")
    print("[" + ", ".join(map(str, node_chord_counts)) + "] @=> int NODE_CHORD_COUNTS[];")
    print()
    print("[" + ", ".join(map(str, succ_offsets)) + "] @=> int SUCC_OFFSETS[];")
    print("[" + ", ".join(map(str, succ_counts)) + "] @=> int SUCC_COUNTS[];")
    print("[" + ", ".join(map(str, succ_targets)) + "] @=> int SUCC_TARGETS[];")

if __name__ == "__main__":
    main()