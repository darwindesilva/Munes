// munes music, chords and bass only

// inputs from unity
global float in_speed;
global int   in_grounded;
global int   in_takeoff;
global int   in_landed;
global float in_height;
global float in_timeToLand;
global int   in_zone;
global int   in_forceChange;

// outputs for unity, the overlay reads these
global int   out_chordIdx;
global int   out_nodeIdx;
global int   out_graphIdx;

// settings
150.0 => float HEIGHT_TOP;
0.06  => float BASE_VOICE_GAIN;
0.20  => float BASS_VOICE_GAIN;
0.02  => float MIN_SLIDE_RATE;
0.60  => float MAX_SLIDE_RATE;
400   => int   MIN_SLIDE_MS;
10000 => int   MAX_SLIDE_MS;
3     => int   OCTAVES;
100   => int   MIN_AIRTIME_MS;
5.0   => float MIN_TRIGGER_HEIGHT;
6000  => int   FADE_AFTER_MS;
2000  => int   FADE_DURATION_MS;

// generated block start

// made by generate_chuck_graph.py, change the python file instead of this block
// graph order: dar, jazz, hinge_to_Am, dean_minor, lydian_haze, dorian_haze

6 => int NOTES_PER_CHORD;
56 => int NODE_COUNT;
70 => int CHORD_COUNT;
6 => int NUM_GRAPHS;

[0, 5, 13, 18, 31, 43] @=> int GRAPH_NODE_OFFSETS[];
[5, 8, 5, 13, 12, 13] @=> int GRAPH_NODE_COUNTS[];

[
   48,  52,  55,  59,  -1,  -1,  // 0 A1
   48,  52,  55,  59,  50,  -1,  // 1 A1
   50,  53,  57,  48,  -1,  -1,  // 2 A2
   50,  53,  57,  48,  64,  -1,  // 3 A2
   48,  55,  64,  -1,  -1,  -1,  // 4 A3
   48,  55,  59,  -1,  -1,  -1,  // 5 A3
   48,  52,  55,  57,  -1,  -1,  // 6 A4
   50,  53,  57,  60,  -1,  -1,  // 7 A5
   50,  53,  57,  60,  -1,  -1,  // 8 Dm7
   55,  59,  62,  65,  -1,  -1,  // 9 G7
   48,  52,  55,  59,  -1,  -1,  // 10 Cmaj7
   45,  48,  52,  55,  -1,  -1,  // 11 Am7
   50,  54,  57,  60,  -1,  -1,  // 12 D7
   43,  47,  50,  54,  -1,  -1,  // 13 Gmaj7
   53,  57,  60,  64,  -1,  -1,  // 14 Fmaj7
   52,  55,  59,  62,  -1,  -1,  // 15 Em7
   48,  52,  55,  59,  -1,  -1,  // 16 Cmaj7
   52,  55,  59,  62,  -1,  -1,  // 17 Em7
   45,  48,  52,  55,  -1,  -1,  // 18 Am7
   40,  44,  47,  50,  -1,  -1,  // 19 E7
   45,  48,  52,  -1,  -1,  -1,  // 20 Am
   48,  51,  55,  58,  62,  67,  // 21 Cm9
   48,  51,  55,  58,  62,  65,  // 22 Cm11
   48,  51,  55,  59,  62,  67,  // 23 CmMaj9
   48,  51,  55,  58,  60,  63,  // 24 Abmaj9
   48,  51,  56,  60,  63,  67,  // 25 Fm9
   50,  53,  58,  60,  62,  65,  // 26 Bbadd9
   51,  55,  58,  62,  65,  70,  // 27 Ebmaj9
   50,  55,  60,  62,  65,  68,  // 28 G7sus
   50,  53,  58,  62,  65,  69,  // 29 Gm9
   49,  53,  56,  60,  63,  67,  // 30 Dbmaj9
   52,  56,  59,  63,  66,  71,  // 31 Emaj9
   50,  53,  56,  59,  62,  65,  // 32 Bdim7
   51,  55,  58,  62,  65,  70,  // 33 Aeolian_walk
   50,  53,  58,  60,  62,  65,  // 34 Aeolian_walk
   48,  51,  55,  58,  62,  67,  // 35 Aeolian_walk
   53,  57,  60,  64,  67,  71,  // 36 Fmaj9#11
   50,  55,  57,  59,  62,  67,  // 37 Gadd9
   48,  52,  55,  59,  62,  67,  // 38 Cmaj9
   48,  52,  55,  59,  64,  69,  // 39 Am9
   48,  52,  57,  60,  65,  69,  // 40 Dm9
   50,  53,  57,  60,  64,  69,  // 41 Bbmaj9#11
   48,  51,  55,  58,  60,  63,  // 42 Abmaj9
   52,  56,  59,  63,  66,  71,  // 43 Emaj9
   48,  53,  55,  57,  60,  65,  // 44 Fadd9
   48,  50,  55,  60,  62,  67,  // 45 Csus2
   48,  53,  55,  57,  60,  65,  // 46 Lydian_rise
   50,  55,  57,  59,  62,  67,  // 47 Lydian_rise
   48,  52,  55,  59,  64,  69,  // 48 Lydian_rise
   48,  52,  55,  59,  62,  67,  // 49 Chromatic_mediants
   48,  51,  55,  58,  60,  63,  // 50 Chromatic_mediants
   52,  56,  59,  63,  66,  71,  // 51 Chromatic_mediants
   50,  53,  57,  60,  64,  67,  // 52 Dm11
   50,  53,  57,  60,  64,  69,  // 53 Dm9
   50,  53,  57,  60,  64,  69,  // 54 Bbmaj9#11
   52,  55,  59,  62,  65,  69,  // 55 Em7b9
   53,  57,  60,  64,  67,  71,  // 56 Fmaj9#11
   53,  59,  62,  64,  67,  69,  // 57 G13
   50,  55,  60,  62,  65,  69,  // 58 Gsus9
   48,  52,  55,  59,  62,  67,  // 59 Am11
   50,  53,  57,  59,  62,  65,  // 60 Bm7b5
   48,  52,  56,  59,  62,  66,  // 61 Cmaj9#5
   50,  57,  62,  64,  67,  69,  // 62 Dsus2
   50,  53,  57,  60,  64,  69,  // 63 Dorian_float
   52,  55,  59,  62,  65,  69,  // 64 Dorian_float
   53,  57,  60,  64,  67,  71,  // 65 Dorian_float
   50,  55,  60,  62,  65,  69,  // 66 Dorian_float
   50,  53,  57,  59,  62,  65,  // 67 Cadence_tilt
   52,  55,  59,  62,  65,  69,  // 68 Cadence_tilt
   48,  52,  55,  59,  62,  67,  // 69 Cadence_tilt
] @=> int CHORDS[];

[36, 36, 38, 38, 43, 43, 36, 38, 38, 31, 36, 33, 38, 31, 29, 40, 36, 40, 33, 40, 33, 36, 36, 36, 32, 29, 34, 39, 31, 31, 37, 40, 35, 39, 34, 36, 41, 31, 36, 33, 38, 34, 32, 40, 29, 36, 29, 31, 33, 36, 32, 40, 38, 38, 34, 40, 41, 31, 31, 33, 35, 36, 38, 38, 38, 38, 38, 35, 40, 33] @=> int BASS_NOTES[];

[0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 49, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 67] @=> int NODE_CHORD_OFFSETS[];
[2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 3] @=> int NODE_CHORD_COUNTS[];

[0, 1, 2, 3, 4, 5, 7, 9, 11, 13, 15, 17, 19, 21, 22, 23, 24, 25, 27, 32, 37, 41, 46, 51, 55, 59, 63, 66, 69, 72, 75, 78, 83, 87, 93, 97, 101, 105, 109, 114, 118, 123, 125, 127, 132, 137, 141, 146, 150, 154, 158, 162, 166, 169, 172, 175] @=> int SUCC_OFFSETS[];
[1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 2, 5, 5, 4, 5, 5, 4, 4, 4, 3, 3, 3, 3, 3, 5, 4, 6, 4, 4, 4, 4, 5, 4, 5, 2, 2, 5, 5, 4, 5, 4, 4, 4, 4, 4, 3, 3, 3, 3] @=> int SUCC_COUNTS[];
[1, 2, 3, 4, 0, 6, 7, 7, 5, 8, 5, 9, 10, 10, 8, 7, 8, 6, 12, 8, 5, 14, 15, 16, 17, 14, 13, 19, 20, 21, 23, 22, 18, 22, 24, 25, 30, 18, 21, 22, 29, 22, 24, 27, 28, 23, 19, 25, 27, 23, 30, 25, 18, 21, 26, 21, 18, 23, 26, 18, 21, 24, 29, 18, 24, 22, 18, 22, 21, 21, 19, 24, 18, 19, 21, 22, 21, 25, 32, 33, 36, 37, 34, 31, 33, 34, 40, 34, 35, 31, 37, 38, 42, 35, 31, 32, 36, 32, 33, 36, 39, 31, 33, 37, 32, 33, 38, 31, 36, 37, 33, 34, 31, 42, 31, 35, 40, 41, 33, 31, 34, 32, 41, 33, 36, 31, 34, 44, 48, 46, 45, 54, 43, 47, 49, 50, 53, 44, 47, 52, 49, 43, 47, 51, 50, 55, 48, 46, 44, 52, 43, 50, 47, 49, 48, 43, 50, 45, 44, 47, 46, 51, 46, 43, 50, 55, 44, 47, 45, 43, 44, 54, 43, 49, 50, 43, 44, 47] @=> int SUCC_TARGETS[];

// generated block end

// voices
64 => int MAX_VOICES;
TriOsc voices[MAX_VOICES];
LPF    filters[MAX_VOICES];

int VOICE_COUNT;
NOTES_PER_CHORD * OCTAVES => VOICE_COUNT;
int TOTAL_VOICES;
VOICE_COUNT + 1 => TOTAL_VOICES;
int BASS_IDX;
VOICE_COUNT => BASS_IDX;

for (0 => int i; i < TOTAL_VOICES; i++) {
    new TriOsc @=> voices[i];
    new LPF    @=> filters[i];
    voices[i] => filters[i] => dac;
    3000.0 => filters[i].freq;
    Std.mtof(60) => voices[i].freq;
    0.0 => voices[i].gain;
}
<<< "voice pool:", TOTAL_VOICES, "| chord voices:", VOICE_COUNT, "| chords:", CHORD_COUNT, "| graphs:", NUM_GRAPHS >>>;

// state
int currentGraphIdx;
int currentNodeIdx;
int currentChordInNode;
int currentChordIdx;

float currentFreqs[64];
float targetFreqs[64];
float currentGains[64];
float targetGains[64];
float fadeMultiplier[64];

int   sliding;
int   slideElapsedMs;
int   slideTotalMs;
float slideFreqLerp;

int   msSinceTakeoff;
int   pendingChange;
int   msSinceLastChange;
float fadeAmplitude;

int   lastZone;

// helpers
fun float absFloat(float x) {
    if (x < 0.0) return -x;
    return x;
}

fun int graphFirstNode(int graphIdx) {
    if (graphIdx < 0) { 0 => graphIdx; }
    if (graphIdx >= NUM_GRAPHS) { NUM_GRAPHS - 1 => graphIdx; }
    return GRAPH_NODE_OFFSETS[graphIdx];
}

fun void computeTargets(int chordIdx) {
    if (chordIdx < 0) { 0 => chordIdx; }
    if (chordIdx >= CHORD_COUNT) { CHORD_COUNT - 1 => chordIdx; }

    for (0 => int slot; slot < NOTES_PER_CHORD; slot++) {
        CHORDS[chordIdx * NOTES_PER_CHORD + slot] => int midi;
        for (0 => int o; o < OCTAVES; o++) {
            slot * OCTAVES + o => int idx;
            if (midi < 0) { -1.0 => targetFreqs[idx]; }
            else { Std.mtof(midi + 12 * o) => targetFreqs[idx]; }
        }
    }
    BASS_NOTES[chordIdx] => int bMidi;
    if (bMidi < 0) { -1.0 => targetFreqs[BASS_IDX]; }
    else { Std.mtof(bMidi) => targetFreqs[BASS_IDX]; }
}

fun float octaveWeight(int o, float h) {
    (o * 1.0) / ((OCTAVES - 1) * 1.0) => float center;
    absFloat(h - center) => float d;
    Math.exp(-d * d * 1.5) => float w;
    return w;
}

fun void updateGains(float h) {
    for (0 => int i; i < VOICE_COUNT; i++) {
        if (targetFreqs[i] < 0) { 0.0 => targetGains[i]; }
        else {
            i % OCTAVES => int o;
            octaveWeight(o, h) * BASE_VOICE_GAIN => targetGains[i];
        }
    }
    if (targetFreqs[BASS_IDX] < 0) { 0.0 => targetGains[BASS_IDX]; }
    else if (in_grounded == 1) { BASS_VOICE_GAIN => targetGains[BASS_IDX]; }
    else { 0.0 => targetGains[BASS_IDX]; }
}

fun int pickSuccessorNode(int fromNode) {
    if (fromNode < 0 || fromNode >= NODE_COUNT) return 0;
    SUCC_COUNTS[fromNode] => int n;
    if (n <= 0) return fromNode;
    Math.random2f(0.0, 1.0) => float r;
    (r * n) $ int => int idx;
    if (idx >= n) { n - 1 => idx; }
    return SUCC_TARGETS[SUCC_OFFSETS[fromNode] + idx];
}

fun int globalChordFor(int nodeIdx, int chordInNode) {
    return NODE_CHORD_OFFSETS[nodeIdx] + chordInNode;
}

fun void beginSlideTo(int chordIdx, int ttlMs) {
    float oldTargets[64];
    for (0 => int i; i < TOTAL_VOICES; i++) {
        targetFreqs[i] => oldTargets[i];
    }

    computeTargets(chordIdx);

    for (0 => int i; i < TOTAL_VOICES; i++) {
        if (oldTargets[i] < 0.0 && targetFreqs[i] > 0.0) {
            targetFreqs[i] => currentFreqs[i];
            currentFreqs[i] => voices[i].freq;
        }
    }

    ttlMs => slideTotalMs;
    if (slideTotalMs < MIN_SLIDE_MS) { MIN_SLIDE_MS => slideTotalMs; }
    if (slideTotalMs > MAX_SLIDE_MS) { MAX_SLIDE_MS => slideTotalMs; }

    slideTotalMs / 50 => int ticks;
    if (ticks < 1) { 1 => ticks; }
    1.0 - Math.pow(0.005, 1.0 / ticks) => slideFreqLerp;
    if (slideFreqLerp < MIN_SLIDE_RATE) { MIN_SLIDE_RATE => slideFreqLerp; }
    if (slideFreqLerp > MAX_SLIDE_RATE) { MAX_SLIDE_RATE => slideFreqLerp; }

    0 => slideElapsedMs;
    1 => sliding;
    chordIdx => currentChordIdx;
    0 => msSinceLastChange;

    <<< "CHANGE -> chord", currentChordIdx, "over", slideTotalMs, "ms" >>>;
}

// go to the next chord in the node, or pick a new node when the node is done
fun void stepToNextChord(int ms) {
    currentChordInNode + 1 => int nextChordInNode;
    if (nextChordInNode >= NODE_CHORD_COUNTS[currentNodeIdx]) {
        pickSuccessorNode(currentNodeIdx) => currentNodeIdx;
        0 => nextChordInNode;
    }
    nextChordInNode => currentChordInNode;
    beginSlideTo(globalChordFor(currentNodeIdx, currentChordInNode), ms);
}

// start
0 => currentGraphIdx;
graphFirstNode(currentGraphIdx) => currentNodeIdx;
0 => currentChordInNode;
globalChordFor(currentNodeIdx, currentChordInNode) => currentChordIdx;
computeTargets(currentChordIdx);

in_height => float hRaw;
if (hRaw < 0.0) { 0.0 => hRaw; }
hRaw / HEIGHT_TOP => float h0;
if (h0 > 1.0) { 1.0 => h0; }
updateGains(h0);

for (0 => int i; i < TOTAL_VOICES; i++) {
    if (targetFreqs[i] > 0) {
        targetFreqs[i] => currentFreqs[i];
        currentFreqs[i] => voices[i].freq;
    } else { 0.0 => currentFreqs[i]; }
    targetGains[i] => currentGains[i];
    currentGains[i] => voices[i].gain;
    1.0 => fadeMultiplier[i];
}

0 => sliding;
0 => msSinceTakeoff;
0 => pendingChange;
0 => msSinceLastChange;
1.0 => fadeAmplitude;
in_zone => lastZone;

currentChordIdx => out_chordIdx;
currentNodeIdx => out_nodeIdx;
currentGraphIdx => out_graphIdx;

<<< "munes music starting" >>>;

// main loop
while (true) {

    if (in_grounded == 0) { msSinceTakeoff + 50 => msSinceTakeoff; }
    else                  { msSinceLastChange + 50 => msSinceLastChange; }

    // new zone, switch graph
    if (in_zone != lastZone) {
        in_zone => lastZone;
        in_zone % NUM_GRAPHS => int newGraphIdx;
        if (newGraphIdx != currentGraphIdx) {
            newGraphIdx => currentGraphIdx;
            graphFirstNode(currentGraphIdx) => currentNodeIdx;
            0 => currentChordInNode;
            globalChordFor(currentNodeIdx, currentChordInNode) => int targetChord;
            in_timeToLand => float ttl2;
            if (ttl2 < 0.0) { 4.0 => ttl2; }
            (ttl2 * 1000.0) $ int => int ttl2Ms;
            beginSlideTo(targetChord, ttl2Ms);
            <<< "ZONE ->", in_zone, "| graph:", currentGraphIdx >>>;
        }
    }

    // anything in unity (timeline for example) can ask for a chord change
    if (in_forceChange == 1) {
        0 => in_forceChange;
        stepToNextChord(3000);
    }

    if (in_takeoff == 1) {
        0 => msSinceTakeoff;
        1 => pendingChange;
        <<< "TAKEOFF armed, ttl", in_timeToLand >>>;
    }

    if (pendingChange == 1
        && sliding == 0
        && in_grounded == 0
        && msSinceTakeoff >= MIN_AIRTIME_MS
        && in_height >= MIN_TRIGGER_HEIGHT)
    {
        in_timeToLand => float ttl;
        if (ttl < 0.0) { 4.0 => ttl; }
        if (ttl > 30.0) { 30.0 => ttl; }
        (ttl * 1000.0) $ int => int ttlMs;

        stepToNextChord(ttlMs);
        0 => pendingChange;
    }

    if (in_landed == 1) {
        if (pendingChange == 1) {
            <<< "never reached the height gate, change cancelled" >>>;
        }
        0 => pendingChange;
        0 => msSinceTakeoff;
    }

    // fade out when nothing is happening
    1.0 => float targetFade;
    if (in_grounded == 1 && sliding == 0 && pendingChange == 0) {
        if (msSinceLastChange >= FADE_AFTER_MS) {
            msSinceLastChange - FADE_AFTER_MS => int fadedMs;
            if (fadedMs > FADE_DURATION_MS) { FADE_DURATION_MS => fadedMs; }
            1.0 - (fadedMs * 1.0) / FADE_DURATION_MS => targetFade;
            if (targetFade < 0.0) { 0.0 => targetFade; }
        }
    }

    50.0 / FADE_DURATION_MS => float fadeRate;
    if (fadeAmplitude < targetFade) {
        fadeAmplitude + fadeRate => fadeAmplitude;
        if (fadeAmplitude > targetFade) { targetFade => fadeAmplitude; }
    } else if (fadeAmplitude > targetFade) {
        fadeAmplitude - fadeRate => fadeAmplitude;
        if (fadeAmplitude < targetFade) { targetFade => fadeAmplitude; }
    }

    for (0 => int i; i < TOTAL_VOICES; i++) { fadeAmplitude => fadeMultiplier[i]; }

    in_height => float hR;
    if (hR < 0.0) { 0.0 => hR; }
    hR / HEIGHT_TOP => float h;
    if (h > 1.0) { 1.0 => h; }
    updateGains(h);

    // faster is brighter
    (2500.0 + in_speed * 50.0) => float baseFilt;
    if (baseFilt > 8000.0) { 8000.0 => baseFilt; }

    // slide the pitches
    0.15 => float baseLerp;
    for (0 => int i; i < TOTAL_VOICES; i++) {
        if (targetFreqs[i] > 0) {
            baseLerp => float thisLerp;
            if (sliding == 1) { slideFreqLerp => thisLerp; }
            currentFreqs[i] + (targetFreqs[i] - currentFreqs[i]) * thisLerp => currentFreqs[i];
            currentFreqs[i] => voices[i].freq;
            if (i < VOICE_COUNT) { baseFilt => filters[i].freq; }
        }
    }

    if (sliding == 1) {
        slideElapsedMs + 50 => slideElapsedMs;
        if (slideElapsedMs >= slideTotalMs) { 0 => sliding; }
    }

    // smooth the volume
    0.08 => float gainLerp;
    for (0 => int i; i < TOTAL_VOICES; i++) {
        currentGains[i] + (targetGains[i] - currentGains[i]) * gainLerp => currentGains[i];
        currentGains[i] * fadeMultiplier[i] => voices[i].gain;
    }

    currentChordIdx => out_chordIdx;
    currentNodeIdx => out_nodeIdx;
    currentGraphIdx => out_graphIdx;

    50::ms => now;
}