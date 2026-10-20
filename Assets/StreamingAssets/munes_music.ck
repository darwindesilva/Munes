// unity inputs
global float in_speed;
global int   in_grounded;
global int   in_takeoff;
global int   in_landed;
global float in_height;
global float in_timeToLand;

// tunables
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

// staccato tunables
0.015 => float STACCATO_GAIN;
0.5   => float STACCATO_MIN_SEC;
4.0   => float STACCATO_MAX_SEC;
10.0  => float STACCATO_SPEED_K;
0.5   => float STACCATO_REVERB_MIX;
1800  => float STACCATO_FILT;


// ---------------------------------PYTHON OUTPUT HERE--------------------------------------

5 => int NOTES_PER_CHORD;
125 => int NODE_COUNT;
220 => int CHORD_COUNT;

[
    48,  52,  55,  59,  -1,
    48,  52,  55,  59,  50,
    50,  53,  57,  48,  -1,
    50,  53,  57,  48,  64,
    48,  55,  64,  -1,  -1,
    48,  55,  59,  -1,  -1,
    48,  52,  55,  57,  -1,
    50,  53,  57,  60,  -1,
    50,  54,  57,  61,  -1,
    50,  54,  57,  61,  52,
    52,  55,  59,  50,  -1,
    52,  55,  59,  50,  66,
    50,  57,  66,  -1,  -1,
    50,  57,  61,  -1,  -1,
    50,  54,  57,  59,  -1,
    52,  55,  59,  62,  -1,
    51,  55,  58,  62,  -1,
    51,  55,  58,  62,  53,
    53,  56,  60,  51,  -1,
    53,  56,  60,  51,  67,
    51,  58,  67,  -1,  -1,
    51,  58,  62,  -1,  -1,
    51,  55,  58,  60,  -1,
    53,  56,  60,  63,  -1,
    53,  57,  60,  64,  -1,
    53,  57,  60,  64,  55,
    55,  58,  62,  53,  -1,
    55,  58,  62,  53,  69,
    53,  60,  69,  -1,  -1,
    53,  60,  64,  -1,  -1,
    53,  57,  60,  62,  -1,
    55,  58,  62,  65,  -1,
    55,  59,  62,  66,  -1,
    55,  59,  62,  66,  57,
    57,  60,  64,  55,  -1,
    57,  60,  64,  55,  71,
    55,  62,  71,  -1,  -1,
    55,  62,  66,  -1,  -1,
    55,  59,  62,  64,  -1,
    57,  60,  64,  67,  -1,
    50,  53,  57,  60,  -1,
    50,  53,  57,  60,  64,
    55,  59,  62,  65,  -1,
    55,  59,  62,  65,  69,
    52,  55,  59,  60,  -1,
    52,  55,  59,  60,  62,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    50,  53,  57,  60,  -1,
    52,  55,  59,  62,  -1,
    52,  55,  59,  62,  66,
    57,  61,  64,  67,  -1,
    57,  61,  64,  67,  71,
    54,  57,  61,  62,  -1,
    54,  57,  61,  62,  64,
    59,  62,  66,  69,  -1,
    59,  62,  66,  69,  73,
    52,  55,  59,  62,  -1,
    53,  56,  60,  63,  -1,
    53,  56,  60,  63,  67,
    58,  62,  65,  68,  -1,
    58,  62,  65,  68,  72,
    55,  58,  62,  63,  -1,
    55,  58,  62,  63,  65,
    60,  63,  67,  70,  -1,
    60,  63,  67,  70,  74,
    53,  56,  60,  63,  -1,
    55,  58,  62,  65,  -1,
    55,  58,  62,  65,  69,
    60,  64,  67,  70,  -1,
    60,  64,  67,  70,  74,
    57,  60,  64,  65,  -1,
    57,  60,  64,  65,  67,
    62,  65,  69,  72,  -1,
    62,  65,  69,  72,  76,
    55,  58,  62,  65,  -1,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    62,  66,  69,  72,  -1,
    62,  66,  69,  72,  76,
    59,  62,  66,  67,  -1,
    59,  62,  66,  67,  69,
    64,  67,  71,  74,  -1,
    64,  67,  71,  74,  78,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    53,  57,  60,  64,  -1,
    53,  57,  60,  64,  67,
    52,  55,  59,  60,  -1,
    52,  55,  59,  60,  62,
    55,  60,  62,  67,  -1,
    55,  59,  62,  65,  -1,
    57,  60,  64,  67,  -1,
    59,  62,  66,  69,  -1,
    59,  62,  66,  69,  73,
    55,  59,  62,  66,  -1,
    55,  59,  62,  66,  69,
    54,  57,  61,  62,  -1,
    54,  57,  61,  62,  64,
    57,  62,  64,  69,  -1,
    57,  61,  64,  67,  -1,
    59,  62,  66,  69,  -1,
    60,  63,  67,  70,  -1,
    60,  63,  67,  70,  74,
    56,  60,  63,  67,  -1,
    56,  60,  63,  67,  70,
    55,  58,  62,  63,  -1,
    55,  58,  62,  63,  65,
    58,  63,  65,  70,  -1,
    58,  62,  65,  68,  -1,
    60,  63,  67,  70,  -1,
    62,  65,  69,  72,  -1,
    62,  65,  69,  72,  76,
    58,  62,  65,  69,  -1,
    58,  62,  65,  69,  72,
    57,  60,  64,  65,  -1,
    57,  60,  64,  65,  67,
    60,  65,  67,  72,  -1,
    60,  64,  67,  70,  -1,
    62,  65,  69,  72,  -1,
    64,  67,  71,  74,  -1,
    64,  67,  71,  74,  78,
    60,  64,  67,  71,  -1,
    60,  64,  67,  71,  74,
    59,  62,  66,  67,  -1,
    59,  62,  66,  67,  69,
    62,  67,  69,  74,  -1,
    62,  66,  69,  72,  -1,
    64,  67,  71,  74,  -1,
    52,  55,  59,  62,  -1,
    52,  55,  59,  62,  69,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    50,  53,  57,  60,  -1,
    50,  53,  57,  60,  64,
    55,  60,  62,  67,  -1,
    55,  59,  62,  65,  -1,
    52,  55,  59,  62,  -1,
    54,  57,  61,  64,  -1,
    54,  57,  61,  64,  71,
    59,  62,  66,  69,  -1,
    59,  62,  66,  69,  73,
    52,  55,  59,  62,  -1,
    52,  55,  59,  62,  66,
    57,  62,  64,  69,  -1,
    57,  61,  64,  67,  -1,
    54,  57,  61,  64,  -1,
    55,  58,  62,  65,  -1,
    55,  58,  62,  65,  72,
    60,  63,  67,  70,  -1,
    60,  63,  67,  70,  74,
    53,  56,  60,  63,  -1,
    53,  56,  60,  63,  67,
    58,  63,  65,  70,  -1,
    58,  62,  65,  68,  -1,
    55,  58,  62,  65,  -1,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  74,
    62,  65,  69,  72,  -1,
    62,  65,  69,  72,  76,
    55,  58,  62,  65,  -1,
    55,  58,  62,  65,  69,
    60,  65,  67,  72,  -1,
    60,  64,  67,  70,  -1,
    57,  60,  64,  67,  -1,
    59,  62,  66,  69,  -1,
    59,  62,  66,  69,  76,
    64,  67,  71,  74,  -1,
    64,  67,  71,  74,  78,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    62,  67,  69,  74,  -1,
    62,  66,  69,  72,  -1,
    59,  62,  66,  69,  -1,
    53,  57,  60,  64,  -1,
    53,  57,  60,  64,  67,
    55,  58,  62,  65,  -1,
    55,  58,  62,  65,  69,
    52,  55,  59,  60,  -1,
    52,  55,  59,  60,  62,
    53,  57,  60,  64,  -1,
    53,  57,  60,  64,  67,
    57,  60,  64,  67,  -1,
    55,  59,  62,  66,  -1,
    55,  59,  62,  66,  69,
    57,  60,  64,  67,  -1,
    57,  60,  64,  67,  71,
    54,  57,  61,  62,  -1,
    54,  57,  61,  62,  64,
    55,  59,  62,  66,  -1,
    55,  59,  62,  66,  69,
    59,  62,  66,  69,  -1,
    56,  60,  63,  67,  -1,
    56,  60,  63,  67,  70,
    58,  61,  65,  68,  -1,
    58,  61,  65,  68,  72,
    55,  58,  62,  63,  -1,
    55,  58,  62,  63,  65,
    56,  60,  63,  67,  -1,
    56,  60,  63,  67,  70,
    60,  63,  67,  70,  -1,
    58,  62,  65,  69,  -1,
    58,  62,  65,  69,  72,
    60,  63,  67,  70,  -1,
    60,  63,  67,  70,  74,
    57,  60,  64,  65,  -1,
    57,  60,  64,  65,  67,
    58,  62,  65,  69,  -1,
    58,  62,  65,  69,  72,
    62,  65,  69,  72,  -1,
    60,  64,  67,  71,  -1,
    60,  64,  67,  71,  74,
    62,  65,  69,  72,  -1,
    62,  65,  69,  72,  76,
    59,  62,  66,  67,  -1,
    59,  62,  66,  67,  69,
    60,  64,  67,  71,  -1,
    60,  64,  67,  71,  74,
    64,  67,  71,  74,  -1,
] @=> int CHORDS[];

[ 36,  36,  38,  38,  43,  43,  36,  38,  38,  38,  40,  40,  45,  45,  38,  40,  39,  39,  41,  41,  46,  46,  39,  41,  41,  41,  43,  43,  48,  48,  41,  43,  43,  43,  45,  45,  50,  50,  43,  45,  38,  38,  43,  43,  36,  36,  33,  33,  38,  40,  40,  45,  45,  38,  38,  35,  35,  40,  41,  41,  46,  46,  39,  39,  36,  36,  41,  43,  43,  48,  48,  41,  41,  38,  38,  43,  45,  45,  50,  50,  43,  43,  40,  40,  45,  33,  33,  41,  41,  36,  36, 43,  43,  33,  35,  35,  43,  43,  38,  38,  45,  45,  35,  36,  36,  44,  44,  39,  39,  46,  46,  36,  38,  38,  46,  46,  41,  41,  48,  48,  38,  40,  40,  48,  48,  43,  43,  50,  50,  40,  40,  40,  33,  33,  38,  38,  43,  43,  40,  42,  42,  35,  35,  40,  40,  45,  45,  42,  43,  43,  36,  36,  41,  41,  46,  46,  43,  45,  45,  38,  38,  43,  43,  48,  48,  45,  47,  47,  40,  40,  45,  45,  50,  50,  47,  41,  41,  43,  43,  36,  36,  41, 41,  33,  43,  43,  45,  45,  38,  38,  43,  43,  35,  44,  44,  46,  46,  39,  39,  44,  44,  36,  46,  46,  48,  48,  41,  41,  46,  46,  38,  48,  48,  50,  50,  43,  43,  48,  48,  40] @=> int BASS_NOTES[];

[0, 2, 4, 6, 7, 8, 10, 12, 14, 15, 16, 18, 20, 22, 23, 24, 26, 28, 30, 31, 32, 34, 36, 38, 39, 40, 42, 44, 46, 48, 49, 51, 53, 55, 57, 58, 60, 62, 64, 66, 67, 69, 71, 73, 75, 76, 78, 80, 82, 84, 85, 87, 89, 91, 93, 94, 96, 98, 100, 102, 103, 105, 107, 109, 111, 112, 114, 116, 118, 120, 121, 123, 125, 127, 129, 130, 132, 134, 136, 138, 139, 141, 143, 145, 147, 148, 150, 152, 154, 156, 157, 159, 161, 163, 165, 166, 168, 170, 172, 174, 175, 177, 179, 181, 183, 184, 186, 188, 190, 192, 193, 195, 197, 199, 201, 202, 204, 206, 208, 210, 211, 213, 215, 217, 219] @=> int NODE_CHORD_OFFSETS[];

[2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 2, 1] @=> int NODE_CHORD_COUNTS[];

[0, 1, 2, 3, 4, 28, 29, 30, 31, 32, 56, 57, 58, 59, 60, 84, 85, 86, 87, 88, 112, 113, 114, 115, 116, 140, 141, 142, 143, 144, 168, 169, 170, 171, 172, 196, 197, 198, 199, 200, 224, 225, 226, 227, 228, 252, 253, 254, 255, 256, 280, 281, 282, 283, 284, 308, 309, 310, 311, 312, 336, 337, 338, 339, 340, 364, 365, 366, 367, 368, 392, 393, 394, 395, 396, 420, 421, 422, 423, 424, 448, 449, 450, 451, 452, 476, 477, 478, 479, 480, 504, 505, 506, 507, 508, 532, 533, 534, 535, 536, 560, 561, 562, 563, 564, 588, 589, 590, 591, 592, 616, 617, 618, 619, 620, 644, 645, 646, 647, 648, 672, 673, 674, 675, 676] @=> int SUCC_OFFSETS[];

[1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24, 1, 1, 1, 1, 24] @=> int SUCC_COUNTS[];

[1, 2, 3, 4, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 6, 7, 8, 9, 0, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 11, 12, 13, 14, 0, 5, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 16, 17, 18, 19, 0, 5, 10, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 21, 22, 23, 24, 0, 5, 10, 15, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 26, 27, 28, 29, 0, 5, 10, 15, 20, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 31, 32, 33, 34, 0, 5, 10, 15, 20, 25, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 36, 37, 38, 39, 0, 5, 10, 15, 20, 25, 30, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 41, 42, 43, 44, 0, 5, 10, 15, 20, 25, 30, 35, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 46, 47, 48, 49, 0, 5, 10, 15, 20, 25, 30, 35, 40, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 51, 52, 53, 54, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 56, 57, 58, 59, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 61, 62, 63, 64, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 66, 67, 68, 69, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 71, 72, 73, 74, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 76, 77, 78, 79, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 85, 90, 95, 100, 105, 110, 115, 120, 81, 82, 83, 84, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 85, 90, 95, 100, 105, 110, 115, 120, 86, 87, 88, 89, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 90, 95, 100, 105, 110, 115, 120, 91, 92, 93, 94, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 95, 100, 105, 110, 115, 120, 96, 97, 98, 99, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 100, 105, 110, 115, 120, 101, 102, 103, 104, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 105, 110, 115, 120, 106, 107, 108, 109, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 110, 115, 120, 111, 112, 113, 114, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 115, 120, 116, 117, 118, 119, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 120, 121, 122, 123, 124, 0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115] @=> int SUCC_TARGETS[];

//-----------------------------------END OF PYTHON OUTPUT-----------------------------------------------


// chord voices (sine, smooth)
64 => int MAX_VOICES;
SinOsc voices[MAX_VOICES];
LPF    filters[MAX_VOICES];

int VOICE_COUNT;
NOTES_PER_CHORD * OCTAVES => VOICE_COUNT;
int TOTAL_VOICES;
VOICE_COUNT => TOTAL_VOICES;

for (0 => int i; i < VOICE_COUNT; i++) {
    new SinOsc @=> voices[i];
    new LPF    @=> filters[i];
    voices[i] => filters[i] => dac;
    3000.0 => filters[i].freq;
    Std.mtof(60) => voices[i].freq;
    0.0 => voices[i].gain;
}

// bass (triangle, separate chain so low sines don't click)
TriOsc bassOsc => LPF bassFilt => dac;
600.0 => bassFilt.freq;
Std.mtof(36) => bassOsc.freq;
0.0 => bassOsc.gain;

// staccato voices with their own reverb
int STACCATO_COUNT;
NOTES_PER_CHORD => STACCATO_COUNT;

SinOsc staccatoOscs[MAX_VOICES];
LPF    staccatoFilt[MAX_VOICES];
ADSR   staccatoEnv[MAX_VOICES];

JCRev staccatoRev => dac;
STACCATO_REVERB_MIX => staccatoRev.mix;

for (0 => int i; i < STACCATO_COUNT; i++) {
    new SinOsc @=> staccatoOscs[i];
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

<<< "voices:", TOTAL_VOICES, "+", STACCATO_COUNT, "staccato" >>>;

// state
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

// bass state
float bassCurrentFreq;
float bassTargetFreq;
float bassCurrentGain;
float bassTargetGain;

// helpers
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
    if (bMidi < 0) { -1.0 => bassTargetFreq; }
    else { Std.mtof(bMidi) => bassTargetFreq; }
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
    if (bassTargetFreq < 0) { 0.0 => bassTargetGain; }
    else if (in_grounded == 1) { BASS_VOICE_GAIN => bassTargetGain; }
    else { 0.0 => bassTargetGain; }
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
    for (0 => int i; i < VOICE_COUNT; i++) {
        targetFreqs[i] => oldTargets[i];
    }
    bassTargetFreq => float oldBassTarget;

    computeTargets(chordIdx);

    for (0 => int i; i < VOICE_COUNT; i++) {
        if (oldTargets[i] < 0.0 && targetFreqs[i] > 0.0) {
            targetFreqs[i] => currentFreqs[i];
            currentFreqs[i] => voices[i].freq;
        }
    }
    if (oldBassTarget < 0.0 && bassTargetFreq > 0.0) {
        bassTargetFreq => bassCurrentFreq;
        bassCurrentFreq => bassOsc.freq;
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
}

// staccato loop runs on its own
fun void staccatoLoop() {
    while (true) {
        STACCATO_MIN_SEC + (STACCATO_MAX_SEC - STACCATO_MIN_SEC) * Math.exp(-in_speed / STACCATO_SPEED_K) => float interval;

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

// init
0 => currentNodeIdx;
0 => currentChordInNode;
globalChordFor(currentNodeIdx, currentChordInNode) => currentChordIdx;
computeTargets(currentChordIdx);

in_height => float hRaw;
if (hRaw < 0.0) { 0.0 => hRaw; }
hRaw / HEIGHT_TOP => float h0;
if (h0 > 1.0) { 1.0 => h0; }
updateGains(h0);

for (0 => int i; i < VOICE_COUNT; i++) {
    if (targetFreqs[i] > 0) {
        targetFreqs[i] => currentFreqs[i];
        currentFreqs[i] => voices[i].freq;
    } else { 0.0 => currentFreqs[i]; }
    targetGains[i] => currentGains[i];
    currentGains[i] => voices[i].gain;
    1.0 => fadeMultiplier[i];
}

bassTargetFreq => bassCurrentFreq;
if (bassCurrentFreq > 0) { bassCurrentFreq => bassOsc.freq; }
bassTargetGain => bassCurrentGain;
bassCurrentGain => bassOsc.gain;

0 => sliding;
0 => msSinceTakeoff;
0 => pendingChange;
0 => msSinceLastChange;
1.0 => fadeAmplitude;

spork ~ staccatoLoop();

<<< "music starting" >>>;

// main loop
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

    // fade
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
    for (0 => int i; i < VOICE_COUNT; i++) {
        if (targetFreqs[i] > 0) {
            baseLerp => float thisLerp;
            if (sliding == 1) { slideFreqLerp => thisLerp; }
            currentFreqs[i] + (targetFreqs[i] - currentFreqs[i]) * thisLerp => currentFreqs[i];
            currentFreqs[i] => voices[i].freq;
            baseFilt => filters[i].freq;
        }
    }

    // bass freq slide
    if (bassTargetFreq > 0) {
        baseLerp => float bassLerp;
        if (sliding == 1) { slideFreqLerp => bassLerp; }
        bassCurrentFreq + (bassTargetFreq - bassCurrentFreq) * bassLerp => bassCurrentFreq;
        bassCurrentFreq => bassOsc.freq;
    }

    // staccato freq sync
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
    for (0 => int i; i < VOICE_COUNT; i++) {
        currentGains[i] + (targetGains[i] - currentGains[i]) * gainLerp => currentGains[i];
        currentGains[i] * fadeMultiplier[i] => voices[i].gain;
    }
    bassCurrentGain + (bassTargetGain - bassCurrentGain) * gainLerp => bassCurrentGain;
    bassCurrentGain * fadeAmplitude => bassOsc.gain;

    50::ms => now;
}