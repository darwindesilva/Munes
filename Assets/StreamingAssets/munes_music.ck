// ============================================================
// Munes Music Engine
// Inputs from Unity (global variables):
//   in_speed      (float) : ball speed m/s
//   in_grounded   (int)   : 1 if on ground
//   in_takeoff    (int)   : 1 on takeoff frame
//   in_landed     (int)   : 1 on landing frame
//   in_height     (float) : height above surface (m)
//   in_timeToLand (float) : predicted seconds to impact
//   in_quadrant   (int)   : 0-7 octant index
// ============================================================

global float in_speed;
global int   in_grounded;
global int   in_takeoff;
global int   in_landed;
global float in_height;
global float in_timeToLand;
global int   in_quadrant;

// ---- Synth voices ----
SinOsc bass  => LPF bassFilt  => ADSR bassEnv => dac;
SinOsc mid   => LPF midFilt   => ADSR midEnv  => dac;
SinOsc high  => LPF highFilt  => ADSR highEnv => dac;

// Reverb send
JCRev rev => dac;
0.2 => rev.mix;
bass => rev;
mid  => rev;
high => rev;

// ---- Chord definitions (MIDI note numbers) ----
[0, 4, 7]  @=> int chordI[];    // I  (major)
[2, 5, 9]  @=> int chordII[];   // ii (minor)
[4, 7, 11] @=> int chordIII[];  // iii (minor)
[5, 9, 12] @=> int chordIV[];   // IV (major)
[7, 11, 14]@=> int chordV[];    // V  (major)
[9, 12, 16]@=> int chordVI[];   // vi (minor)

// Markov transition probabilities (6x6)
// Row = current chord, column = next chord weight
[
    [0.50, 0.15, 0.05, 0.20, 0.05, 0.05], // from I
    [0.20, 0.40, 0.10, 0.15, 0.10, 0.05], // from ii
    [0.15, 0.10, 0.45, 0.15, 0.10, 0.05], // from iii
    [0.30, 0.10, 0.05, 0.30, 0.20, 0.05], // from IV
    [0.35, 0.05, 0.05, 0.10, 0.35, 0.10], // from V
    [0.25, 0.15, 0.05, 0.10, 0.15, 0.30], // from vi
] @=> float trans[][];

0 => int currentChord;

// ---- Functions ----

fun void playChord(int idx, float vel, dur len) {
    // Root note: map quadrant to a root offset
    (in_quadrant * 2) % 12 => int rootShift;

    int root;
    if (idx == 0) { 0 => root; }
    else if (idx == 1) { 2 => root; }
    else if (idx == 2) { 4 => root; }
    else if (idx == 3) { 5 => root; }
    else if (idx == 4) { 7 => root; }
    else { 9 => root; }

    root + rootShift => int adjustedRoot;

    Std.mtof(adjustedRoot + 36) => bass.freq;   // bass: 2 octaves down
    Std.mtof(adjustedRoot + 60) => mid.freq;    // mid: middle
    Std.mtof(adjustedRoot + 72) => high.freq;   // high: 1 octave up

    vel * 0.3 => bass.gain;
    vel * 0.2 => mid.gain;
    vel * 0.1 => high.gain;

    bassEnv.keyOn(); midEnv.keyOn(); highEnv.keyOn();
    len => now;
    bassEnv.keyOff(); midEnv.keyOff(); highEnv.keyOff();
}

fun void advanceChord() {
    float r; Math.random2f(0, 1) => r;
    float cum;
    0 => cum;
    for (0 => int i; i < 6; i++) {
        trans[currentChord][i] +=> cum;
        if (r < cum) {
            i => currentChord;
            return;
        }
    }
    0 => currentChord; // fallback
}

// ---- Main loop ----
while (true) {
    // Altitude → filter brightness
    300 + (in_height * 2.0) => bassFilt.freq;
    600 + (in_height * 3.0) => midFilt.freq;
    1200 + (in_height * 4.0) => highFilt.freq;

    // Clamp
    if (bassFilt.freq() > 2500) { 2500 => bassFilt.freq; }
    if (midFilt.freq() > 5000) { 5000 => midFilt.freq; }
    if (highFilt.freq() > 9000) { 9000 => highFilt.freq; }

    // Speed → envelope attack/release (faster = shorter)
    (0.005 + 0.05 / (in_speed + 1.0))::second => bassEnv.attackTime;
    (0.005 + 0.05 / (in_speed + 1.0))::second => midEnv.attackTime;

    // Chord triggers
    if (in_takeoff == 1 || in_landed == 1) {
        advanceChord();
        playChord(currentChord, 0.8, 0.4::second);
    }

    // Ambient pulse while grounded
    if (in_grounded == 1) {
        // Slow, quiet pad
        0.15 => bass.gain;
        bassEnv.keyOn();
        80::ms => now;
        bassEnv.keyOff();
    }

    50::ms => now;
}