using System.Collections.Generic;
using UnityEngine;

public class ChordEntry
{
    public int index;
    public string graph;
    public string node;
    public int posInNode;
    public int countInNode;
    public int pyLine;
    public string notes;
    public int[] midi;
    public string bass;
}

// reads chord_info.txt (made by generate_chuck_graph.py) from a Resources folder
public static class ChordInfo
{
    static ChordEntry[] table;

    static void Load()
    {
        var file = Resources.Load<TextAsset>("chord_info");
        if (file == null)
        {
            Debug.LogWarning("chord_info.txt is not in a Resources folder");
            table = new ChordEntry[0];
            return;
        }

        var list = new List<ChordEntry>();
        foreach (string raw in file.text.Split('\n'))
        {
            string line = raw.Trim();
            if (line.Length == 0) continue;

            string[] p = line.Split('|');
            if (p.Length < 9) continue;

            var e = new ChordEntry();
            e.index = int.Parse(p[0]);
            e.graph = p[1];
            e.node = p[2];
            e.posInNode = int.Parse(p[3]);
            e.countInNode = int.Parse(p[4]);
            e.pyLine = int.Parse(p[5]);
            e.notes = p[6];

            string[] m = p[7].Split(new[] { ' ' }, System.StringSplitOptions.RemoveEmptyEntries);
            e.midi = new int[m.Length];
            for (int i = 0; i < m.Length; i++) e.midi[i] = int.Parse(m[i]);

            e.bass = p[8];
            list.Add(e);
        }
        table = list.ToArray();
    }

    public static ChordEntry Get(int index)
    {
        if (table == null) Load();
        if (index < 0 || index >= table.Length) return null;
        return table[index];
    }
}