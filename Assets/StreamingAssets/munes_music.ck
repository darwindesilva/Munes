// ============================================================
// Munes Music v22 — staccato layer + dedicated staccato reverb
// ============================================================

global float in_speed;
global int   in_grounded;
global int   in_takeoff;
global int   in_landed;
global float in_height;
global float in_timeToLand;

// ---- Core tunables ----
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

// ---- Staccato tunables ----
0.015 => float STACCATO_GAIN;        // per-voice gain (very quiet)
0.5   => float STACCATO_MIN_SEC;     // fastest interval
4.0   => float STACCATO_MAX_SEC;     // slowest interval (at rest)
10.0  => float STACCATO_SPEED_K;     // exponential speed sensitivity
0.5  => float STACCATO_REVERB_MIX;  // in-Chuck reverb mix for staccato only
1800 => float STACCATO_FILT;       // staccato LPF cutoff

// ============================================================
// --------- PASTE GENERATED BLOCK BELOW THIS LINE -----------
// ============================================================

5 => int NOTES_PER_CHORD;
125 => int NODE_COUNT;
220 => int CHORD_COUNT;

[
   48,  52,  55,  59,  -1,  //  0
   48,  52,  55,  59,  50,  //  1
   50,  53,  57,  48,  -1,  //  2
   50,  53,  57,  48,  64,  //  3
   48,  55,  64,  -1,  -1,  //  4
   48,  55,  59,  -1,  -1,  //  5
   48,  52,  55,  57,  -1,  //  6
   50,  53,  57,  60,  -1,  //  7
   50,  54,  57,  61,  -1,  //  8
   50,  54,  57,  61,  52,  //  9
   52,  55,  59,  50,  -1,  // 10
   52,  55,  59,  50,  66,  // 11
   50,  57,  66,  -1,  -1,  // 12
   50,  57,  61,  -1,  -1,  // 13
   50,  54,  57,  59,  -1,  // 14
   52,  55,  59,  62,  -1,  // 15
   51,  55,  58,  62,  -1,  // 16
   51,  55,  58,  62,  53,  // 17
   53,  56,  60,  51,  -1,  // 18
   53,  56,  60,  51,  67,  // 19
   51,  58,  67,  -1,  -1,  // 20
   51,  58,  62,  -1,  -1,  // 21
   51,  55,  58,  60,  -1,  // 22
   53,  56,  60,  63,  -1,  // 23
   53,  57,  60,  64,  -1,  // 24
   53,  57,  60,  64,  55,  // 25
   55,  58,  62,  53,  -1,  // 26
   55,  58,  62,  53,  69,  // 27
   53,  60,  69,  -1,  -1,  // 28
   53,  60,  64,  -1,  -1,  // 29
   53,  57,  60,  62,  -1,  // 30
   55,  58,  62,  65,  -1,  // 31
   55,  59,  62,  66,  -1,  // 32
   55,  59,  62,  66,  57,  // 33
   57,  60,  64,  55,  -1,  // 34
   57,  60,  64,  55,  71,  // 35
   55,  62,  71,  -1,  -1,  // 36
   55,  62,  66,  -1,  -1,  // 37
   55,  59,  62,  64,  -1,  // 38
   57,  60,  64,  67,  -1,  // 39
   50,  53,  57,  60,  -1,  // 40
   50,  53,  57,  60,  64,  // 41
   55,  59,  62,  65,  -1,  // 42
   55,  59,  62,  65,  69,  // 43
   52,  55,  59,  60,  -1,  // 44
   52,  55,  59,  60,  62,  // 45
   57,  60,  64,  67,  -1,  // 46
   57,  60,  64,  67,  71,  // 47
   50,  53,  57,  60,  -1,  // 48
   52,  55,  59,  62,  -1,  // 49
   52,  55,  59,  62,  66,  // 50
   57,  61,  64,  67,  -1,  // 51
   57,  61,  64,  67,  71,  // 52
   54,  57,  61,  62,  -1,  // 53
   54,  57,  61,  62,  64,  // 54
   59,  62,  66,  69,  -1,  // 55
   59,  62,  66,  69,  73,  // 56
   52,  55,  59,  62,  -1,  // 57
   53,  56,  60,  63,  -1,  // 58
   53,  56,  60,  63,  67,  // 59
   58,  62,  65,  68,  -1,  // 60
   58,  62,  65,  68,  72,  // 61
   55,  58,  62,  63,  -1,  // 62
   55,  58,  62,  63,  65,  // 63
   60,  63,  67,  70,  -1,  // 64
   60,  63,  67,  70,  74,  // 65
   53,  56,  60,  63,  -1,  // 66
   55,  58,  62,  65,  -1,  // 67
   55,  58,  62,  65,  69,  // 68
   60,  64,  67,  70,  -1,  // 69
   60,  64,  67,  70,  74,  // 70
   57,  60,  64,  65,  -1,  // 71
   57,  60,  64,  65,  67,  // 72
   62,  65,  69,  72,  -1,  // 73
   62,  65,  69,  72,  76,  // 74
   55,  58,  62,  65,  -1,  // 75
   57,  60,  64,  67,  -1,  // 76
   57,  60,  64,  67,  71,  // 77
   62,  66,  69,  72,  -1,  // 78
   62,  66,  69,  72,  76,  // 79
   59,  62,  66,  67,  -1,  // 80
   59,  62,  66,  67,  69,  // 81
   64,  67,  71,  74,  -1,  // 82
   64,  67,  71,  74,  78,  // 83
   57,  60,  64,  67,  -1,  // 84
   57,  60,  64,  67,  -1,  // 85
   57,  60,  64,  67,  71,  // 86
   53,  57,  60,  64,  -1,  // 87
   53,  57,  60,  64,  67,  // 88
   52,  55,  59,  60,  -1,  // 89
   52,  55,  59,  60,  62,  // 90
   55,  60,  62,  67,  -1,  // 91
   55,  59,  62,  65,  -1,  // 92
   57,  60,  64,  67,  -1,  // 93
   59,  62,  66,  69,  -1,  // 94
   59,  62,  66,  69,  73,  // 95
   55,  59,  62,  66,  -1,  // 96
   55,  59,  62,  66,  69,  // 97
   54,  57,  61,  62,  -1,  // 98
   54,  57,  61,  62,  64,  // 99
   57,  62,  64,  69,  -1,  // 100
   57,  61,  64,  67,  -1,  // 101
   59,  62,  66,  69,  -1,  // 102
   60,  63,  67,  70,  -1,  // 103
   60,  63,  67,  70,  74,  // 104
   56,  60,  63,  67,  -1,  // 105
   56,  60,  63,  67,  70,  // 106
   55,  58,  62,  63,  -1,  // 107
   55,  58,  62,  63,  65,  // 108
   58,  63,  65,  70,  -1,  // 109
   58,  62,  65,  68,  -1,  // 110
   60,  63,  67,  70,  -1,  // 111
   62,  65,  69,  72,  -1,  // 112
   62,  65,  69,  72,  76,  // 113
   58,  62,  65,  69,  -1,  // 114
   58,  62,  65,  69,  72,  // 115
   57,  60,  64,  65,  -1,  // 116
   57,  60,  64,  65,  67,  // 117
   60,  65,  67,  72,  -1,  // 118
   60,  64,  67,  70,  -1,  // 119
   62,  65,  69,  72,  -1,  // 120
   64,  67,  71,  74,  -1,  // 121
   64,  67,  71,  74,  78,  // 122
   60,  64,  67,  71,  -1,  // 123
   60,  64,  67,  71,  74,  // 124
   59,  62,  66,  67,  -1,  // 125
   59,  62,  66,  67,  69,  // 126
   62,  67,  69,  74,  -1,  // 127
   62,  66,  69,  72,  -1,  // 128
   64,  67,  71,  74,  -1,  // 129
   52,  55,  59,  62,  -1,  // 130
   52,  55,  59,  62,  69,  // 131
   57,  60,  64,  67,  -1,  // 132
   57,  60,  64,  67,  71,  // 133
   50,  53,  57,  60,  -1,  // 134
   50,  53,  57,  60,  64,  // 135
   55,  60,  62,  67,  -1,  // 136
   55,  59,  62,  65,  -1,  // 137
   52,  55,  59,  62,  -1,  // 138
   54,  57,  61,  64,  -1,  // 139
   54,  57,  61,  64,  71,  // 140
   59,  62,  66,  69,  -1,  // 141
   59,  62,  66,  69,  73,  // 142
   52,  55,  59,  62,  -1,  // 143
   52,  55,  59,  62,  66,  // 144
   57,  62,  64,  69,  -1,  // 145
   57,  61,  64,  67,  -1,  // 146
   54,  57,  61,  64,  -1,  // 147
   55,  58,  62,  65,  -1,  // 148
   55,  58,  62,  65,  72,  // 149
   60,  63,  67,  70,  -1,  // 150
   60,  63,  67,  70,  74,  // 151
   53,  56,  60,  63,  -1,  // 152
   53,  56,  60,  63,  67,  // 153
   58,  63,  65,  70,  -1,  // 154
   58,  62,  65,  68,  -1,  // 155
   55,  58,  62,  65,  -1,  // 156
   57,  60,  64,  67,  -1,  // 157
   57,  60,  64,  67,  74,  // 158
   62,  65,  69,  72,  -1,  // 159
   62,  65,  69,  72,  76,  // 160
   55,  58,  62,  65,  -1,  // 161
   55,  58,  62,  65,  69,  // 162
   60,  65,  67,  72,  -1,  // 163
   60,  64,  67,  70,  -1,  // 164
   57,  60,  64,  67,  -1,  // 165
   59,  62,  66,  69,  -1,  // 166
   59,  62,  66,  69,  76,  // 167
   64,  67,  71,  74,  -1,  // 168
   64,  67,  71,  74,  78,  // 169
   57,  60,  64,  67,  -1,  // 170
   57,  60,  64,  67,  71,  // 171
   62,  67,  69,  74,  -1,  // 172
   62,  66,  69,  72,  -1,  // 173
   59,  62,  66,  69,  -1,  // 174
   53,  57,  60,  64,  -1,  // 175
   53,  57,  60,  64,  67,  // 176
   55,  58,  62,  65,  -1,  // 177
   55,  58,  62,  65,  69,  // 178
   52,  55,  59,  60,  -1,  // 179
   52,  55,  59,  60,  62,  // 180
   53,  57,  60,  64,  -1,  // 181
   53,  57,  60,  64,  67,  // 182
   57,  60,  64,  67,  -1,  // 183
   55,  59,  62,  66,  -1,  // 184
   55,  59,  62,  66,  69,  // 185
   57,  60,  64,  67,  -1,  // 186
   57,  60,  64,  67,  71,  // 187
   54,  57,  61,  62,  -1,  // 188
   54,  57,  61,  62,  64,  // 189
   55,  59,  62,  66,  -1,  // 190
   55,  59,  62,  66,  69,  // 191
   59,  62,  66,  69,  -1,  // 192
   56,  60,  63,  67,  -1,  // 193
   56,  60,  63,  67,  70,  // 194
   58,  61,  65,  68,  -1,  // 195
   58,  61,  65,  68,  72,  // 196
   55,  58,  62,  63,  -1,  // 197
   55,  58,  62,  63,  65,  // 198
   56,  60,  63,  67,  -1,  // 199
   56,  60,  63,  67,  70,  // 200
   60,  63,  67,  70,  -1,  // 201
   58,  62,  65,  69,  -1,  // 202
   58,  62,  65,  69,  72,  // 203
   60,  63,  67,  70,  -1,  // 204
   60,  63,  67,  70,  74,  // 205
   57,  60,  64,  65,  -1,  // 206
   57,  60,  64,  65,  67,  // 207
   58,  62,  65,  69,  -1,  // 208
   58,  62,  65,  69,  72,  // 209
   62,  65,  69,  72,  -1,  // 210
   60,  64,  67,  71,  -1,  // 211
   60,  64,  67,  71,  74,  // 212
   62,  65,  69,  72,  -1,  // 213
   62,  65,  69,  72,  76,  // 214
   59,  62,  66,  67,  -1,  // 215
   59,  62,  66,  67,  69,  // 216
   60,  64,  67,  71,  -1,  // 217
   60,  64,  67,  71,  74,  // 218
   64,  67,  71,  74,  -1,  // 219
] @=> int CHORDS[];

[ 36,  36,  38,  38,  43,  43,  36,  38,  38,  38,  40,  40,  45,  45,  38,  40,  39,  39,  41,  41,  46,  46,  39,  41,  41,  41,  43,  43,  48,  48,  41,  43,  43,  43,  45,  45,  50,  50,  43,  45,  38,  38,  43,  43,  36,  36,  33,  33,  38,  40,  40,  45,  45,  38,  38,  35,  35,  40,  41,  41,  46,  46,  39,  39,  36,  36,  41,  43,  43,  48,  48,  41,  41,  38,  38,  43,  45,  45,  50,  50,  43,  43,  40,  40,  45,  33,  33,  41,  41,  36,  36, 43,  43,  33,  35,  35,  43,  43,  38,  38,  45,  45,  35,  36,  36,  44,  44,  39,  39,  46,  46,  36,  38,  38,  46,  46,  41,  41,  48,  48,  38,  40,  40,  48,  48,  43,  43,  50,  50,  40,  40,  40,  33,  33,  38,  38,  43,  43,  40,  42,  42,  35,  35,  40,  40,  45,  45,  42,  43,  43,  36,  36,  41,  41,  46,  46,  43,  45,  45,  38,  38,  43,  43,  48,  48,  45,  47,  47,  40,  40,  45,  45,  50,  50,  47,  41,  41,  43,  43,  36,  36,  41,41,  33,  43,  43,  45,  45,  38,  38,  43,  43,  35,  44,  44,  46,  46,  39,  39,  44,  44,  36,  46,  46,  48,  48,  41,  41,  46,  46,  38,  48,  48,  50,  50,  43,  43,  48,  48,  40] @=> int BASS_NOTES[];

[0, 2, 4, 6, 7, 8, 10, 12, 14, 15, 16, 18, 20, 22, 23, 24, 26, 28, 30, 31, 32, 34, 36, 38, 39, 40, 42, 44, 46, 48, 49, 51, 53, 55, 57, 58, 60, 62, 64, 66, 67, 69, 71, 73, 75, 76, 78, 80, 82, 84, 85, 87, 89, 91, 93, 94, 96, 98, 100, 102, 103, 105, 107, 109, 111, 112, 114, 116, 118, 120, 121, 123, 125, 127, 129, 130, 132, 134, 136, 138, 139, 141, 143, 145, 147, 148, 150, 152, 154, 156, 157, 159, 161, 163, 165, 166, 168, 170, 172, 174, 175, 177, 179, 181, 183, 184, 186, 188, 190, 192, 193, 195, 197, 199, 201, 202, 204, 206, 208, 210, 211, 213, 215, 217, 219] @=> int NODE_CHORD_OFFSETS[];
[2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1] @=> int NODE_CHORD_COUNTS[];

[0, 1, 2, 3, 4, 28, 29, 30, 31, 32, 56, 57, 58, 59, 60, 84, 85, 86, 87, 88, 112, 113, 114, 115, 116, 140, 141, 142, 143, 144, 168, 169, 170, 171, 172, 196, 197, 198, 199, 200, 224, 225, 226, 227, 228, 252, 253, 254, 255, 256, 280, 281, 282, 283, 284, 308, 309, 310, 311, 312, 336, 337, 338, 339, 340, 364, 365, 366, 367, 368, 392, 393, 394, 395, 396, 420, 421, 422, 423, 424, 448, 449, 450, 451, 452, 476, 477, 478, 479, 480, 504, 505, 506, 507, 508, 532,533, 534, 535, 536, 560, 561, 562, 563, 564, 588, 589, 590, 591, 592, 616, 617, 618, 619, 620, 644, 645, 646, 647, 648, 672, 673, 674, 675, 676] @=> int SUCC_OFFSETS[];
[1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1,1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24] @=> int SUCC_COUNTS[];
[1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 6, 7, 8, 9, 0, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 11, 12, 13, 14, 0, 5, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 16, 17, 18, 19, 0, 5, 10, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 21, 22, 23, 24, 0, 5, 10, 15, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 26, 27, 28, 29, 0, 5, 10, 15, 20, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 31, 32, 33, 34, 0, 5, 10, 15, 20, 25, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 36, 37, 38, 39, 0, 5, 10, 15, 20, 25, 30, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 41, 42, 43, 44, 0, 5, 10, 15, 20, 25, 30, 35, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 46, 47, 48, 49, 0, 5, 10, 15, 20, 25, 30, 35, 40, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115,120, 51, 52, 53, 54, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 56, 57, 58, 59, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 61, 62, 63, 64, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 66, 67, 68, 69, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 71, 72, 73, 74, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 76, 77, 78, 79, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 85, 90, 95, 100, 105, 110, 115, 120, 81, 82, 83, 84, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 85, 90, 95, 100, 105, 110, 115, 120, 86, 87, 88, 89, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 90, 95, 100, 105, 110, 115, 120, 91, 92, 93, 94, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 95, 100, 105, 110, 115, 120, 96, 97, 98, 99, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 100, 105,110, 115, 120, 101, 102, 103, 104, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 105, 110, 115, 120, 106, 107, 108, 109, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 110, 115, 120, 111, 112, 113, 114, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 115, 120, 116, 117, 118, 119, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 120, 121, 122, 123, 124, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115] @=> int SUCC_TARGETS[];


// ============================================================
// --------- END OF GENERATED BLOCK --------------------------
// ============================================================

// ---- Chord voices + bass ----
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

// ---- Staccato layer (separate chain with own reverb) ----
int STACCATO_COUNT;
NOTES_PER_CHORD => STACCATO_COUNT;

TriOsc staccatoOscs[MAX_VOICES];
LPF    staccatoFilt[MAX_VOICES];
ADSR   staccatoEnv[MAX_VOICES];

JCRev staccatoRev => dac;
STACCATO_REVERB_MIX => staccatoRev.mix;

for (0 => int i; i < STACCATO_COUNT; i++) {
    new TriOsc @=> staccatoOscs[i];
    new LPF    @=> staccatoFilt[i];
    new ADSR   @=> staccatoEnv[i];

    staccatoOscs[i] => staccatoFilt[i] => staccatoEnv[i] => staccatoRev;

    STACCATO_FILT => staccatoFilt[i].freq;
    Std.mtof(60) => staccatoOscs[i].freq;
    0.0 => staccatoOscs[i].gain;

    0.004::second => staccatoEnv[i].attackTime;
    0.06::second  => staccatoEnv[i].decayTime;
    0.0           => staccatoEnv[i].sustainLevel;
    0.20::second  => staccatoEnv[i].releaseTime;
}

<<< "voices:", TOTAL_VOICES, "+", STACCATO_COUNT, "staccato | chords:", CHORD_COUNT, "| nodes:", NODE_COUNT >>>;

// ---- State ----
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

// ---- Helpers ----
fun float absFloat(float x) {
    if (x < 0.0) return -x;
    return x;
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

// ---- Staccato shred ----
fun void staccatoLoop() {
    while (true) {
        // Interval: fast at high speed, slow at rest
        STACCATO_MIN_SEC + (STACCATO_MAX_SEC - STACCATO_MIN_SEC) * Math.exp(-in_speed / STACCATO_SPEED_K) => float interval;

        // Only fire when chord is audible
        if (fadeAmplitude >= 0.3) {
            0 => int anyOn;
            for (0 => int i; i < STACCATO_COUNT; i++) {
                i * OCTAVES + (OCTAVES - 1) => int topIdx;
                if (currentFreqs[topIdx] > 0) {
                    currentFreqs[topIdx] => staccatoOscs[i].freq;
                    STACCATO_GAIN * fadeAmplitude => staccatoOscs[i].gain;
                    staccatoEnv[i].keyOn();
                    1 => anyOn;
                }
            }
            if (anyOn > 0) {
                30::ms => now;
                for (0 => int i; i < STACCATO_COUNT; i++) {
                    staccatoEnv[i].keyOff();
                }
            }
        }

        interval::second => now;
    }
}

// ---- Init ----
0 => currentNodeIdx;
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

// Start staccato shred
spork ~ staccatoLoop();

<<< "=== Munes Music v22 starting ===" >>>;

// ---- Main loop ----
while (true) {

    if (in_grounded == 0) { msSinceTakeoff + 50 => msSinceTakeoff; }
    else                  { msSinceLastChange + 50 => msSinceLastChange; }

    if (in_takeoff == 1) {
        0 => msSinceTakeoff;
        1 => pendingChange;
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

    (2500.0 + in_speed * 50.0) => float baseFilt;
    if (baseFilt > 8000.0) { 8000.0 => baseFilt; }

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

    // Sync staccato voice frequencies to top octave of current chord
    for (0 => int i; i < STACCATO_COUNT; i++) {
        i * OCTAVES + (OCTAVES - 1) => int topIdx;
        if (currentFreqs[topIdx] > 0) {
            currentFreqs[topIdx] => staccatoOscs[i].freq;
        }
    }

    if (sliding == 1) {
        slideElapsedMs + 50 => slideElapsedMs;
        if (slideElapsedMs >= slideTotalMs) { 0 => sliding; }
    }

    0.08 => float gainLerp;
    for (0 => int i; i < TOTAL_VOICES; i++) {
        currentGains[i] + (targetGains[i] - currentGains[i]) * gainLerp => currentGains[i];
        currentGains[i] * fadeMultiplier[i] => voices[i].gain;
    }

    50::ms => now;
}