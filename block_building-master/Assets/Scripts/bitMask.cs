using System;
using UnityEngine;

public static class BitMask {
    public static int GetBitMask(GridElement[] neaGridElements) {
        int bitMask = 0;
        for (int i = 0; i < 8; i++) {
            if (neaGridElements[i] != null && neaGridElements[i].GetEnabled()) {
                bitMask += (int)(Mathf.Pow(2, i));
            }
        }
        return bitMask;
    }
}
