// ============================================================
// Munes Music v17 — chords + bass only, no arp/percussion
// ============================================================

// ---- Unity inputs ----
global float in_speed;
global int   in_grounded;
global int   in_takeoff;
global int   in_landed;
global float in_height;
global float in_timeToLand;
global int   in_zone;

// ---- Tunables ----
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

// ============================================================
// --------- PASTE GENERATED BLOCK BELOW THIS LINE -----------
// ============================================================

5 => int NOTES_PER_CHORD;
18 => int NODE_COUNT;
21 => int CHORD_COUNT;
3 => int NUM_GRAPHS;

// Graph → [start global node, count]
[0, 5, 13] @=> int GRAPH_NODE_OFFSETS[];
[5, 8, 5]  @=> int GRAPH_NODE_COUNTS[];

// All chords (global indices)
[
   48,  52,  55,  59,  -1,  //  0
   48,  52,  55,  59,  50,  //  1
   50,  53,  57,  48,  -1,  //  2
   50,  53,  57,  48,  64,  //  3
   48,  55,  64,  -1,  -1,  //  4
   48,  55,  59,  -1,  -1,  //  5
   48,  52,  55,  57,  -1,  //  6
   50,  53,  57,  60,  -1,  //  7
   50,  53,  57,  60,  -1,  //  8
   55,  59,  62,  65,  -1,  //  9
   48,  52,  55,  59,  -1,  // 10
   45,  48,  52,  55,  -1,  // 11
   50,  54,  57,  60,  -1,  // 12
   43,  47,  50,  54,  -1,  // 13
   53,  57,  60,  64,  -1,  // 14
   52,  55,  59,  62,  -1,  // 15
   48,  52,  55,  59,  -1,  // 16
   52,  55,  59,  62,  -1,  // 17
   45,  48,  52,  55,  -1,  // 18
   40,  44,  47,  50,  -1,  // 19
   45,  48,  52,  -1,  -1,  // 20
] @=> int CHORDS[];

[ 36,  36,  38,  38,  43,  43,  36,  38,  38,  31,  36,  33,  38,  31,  29,  40,  36,  40,  33,  40,  33] @=> int BASS_NOTES[];

[0, 2, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20] @=> int NODE_CHORD_OFFSETS[];
[2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] @=> int NODE_CHORD_COUNTS[];

[0, 1, 2, 3, 4, 5, 7, 9, 11, 13, 15, 17, 19, 21, 22, 23, 24, 25] @=> int SUCC_OFFSETS[];
[1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 2] @=> int SUCC_COUNTS[];
[1, 2, 3, 4, 0, 6, 7, 7, 5, 8, 5, 9, 10, 10, 8, 7, 8, 6, 12, 8, 5, 14, 15, 16, 17, 14, 13] @=> int SUCC_TARGETS[];

// Human-readable summary:
//   graph[0] = 'dar'  (5 nodes, starting at global node 0)
//   graph[1] = 'jazz'  (8 nodes, starting at global node 5)
//   graph[2] = 'hinge_to_Am'  (5 nodes, starting at global node 13)

// ============================================================
// --------- END OF GENERATED BLOCK --------------------------
// ============================================================

// ---- Voice pool ----
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

// ---- State ----
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

// ---- Helpers ----
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

    <<< "CHANGE → chord", currentChordIdx, "over", slideTotalMs, "ms" >>>;
}

// ---- Init ----
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

<<< "=== Munes Music v17 starting ===" >>>;

// ---- Main loop ----
while (true) {

    if (in_grounded == 0) { msSinceTakeoff + 50 => msSinceTakeoff; }
    else                  { msSinceLastChange + 50 => msSinceLastChange; }

    // Zone change → switch graph
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
            <<< "ZONE →", in_zone, "| graph:", currentGraphIdx >>>;
        }
    }

    if (in_takeoff == 1) {
        0 => msSinceTakeoff;
        1 => pendingChange;
        <<< "TAKEOFF armed (ttl≈", in_timeToLand, "s)" >>>;
    }

    if (pendingChange == 1
        && sliding == 0
        && in_grounded == 0
        && msSinceTakeoff >= MIN_AIRTIME_MS
        && in_height >= MIN_TRIGGER_HEIGHT)
    {
        currentChordInNode + 1 => int nextChordInNode;
        if (nextChordInNode >= NODE_CHORD_COUNTS[currentNodeIdx]) {
            pickSuccessorNode(currentNodeIdx) => currentNodeIdx;
            0 => nextChordInNode;
        }
        nextChordInNode => currentChordInNode;
        globalChordFor(currentNodeIdx, currentChordInNode) => int nextChordIdx;

        in_timeToLand => float ttl;
        if (ttl < 0.0) { 4.0 => ttl; }
        if (ttl > 30.0) { 30.0 => ttl; }
        (ttl * 1000.0) $ int => int ttlMs;

        beginSlideTo(nextChordIdx, ttlMs);
        0 => pendingChange;
    }

    if (in_landed == 1) {
        if (pendingChange == 1) {
            <<< "  never reached height gate — change cancelled" >>>;
        }
        0 => pendingChange;
        0 => msSinceTakeoff;
    }

    // Symmetric fade
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

    // Filter brightness by speed
    (2500.0 + in_speed * 50.0) => float baseFilt;
    if (baseFilt > 8000.0) { 8000.0 => baseFilt; }

    // Frequency slide
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

    // Gain smoothing
    0.08 => float gainLerp;
    for (0 => int i; i < TOTAL_VOICES; i++) {
        currentGains[i] + (targetGains[i] - currentGains[i]) * gainLerp => currentGains[i];
        currentGains[i] * fadeMultiplier[i] => voices[i].gain;
    }

    50::ms => now;
}