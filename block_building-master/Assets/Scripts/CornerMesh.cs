using System;
using System.Collections.Generic;
using UnityEngine;

public class CornerMesh : MonoBehaviour {
    public static CornerMesh instance;
    public GameObject mesh;
    private Dictionary<String, Mesh> _meshes = new Dictionary<string, Mesh>();
    
    
    // Start is called before the first frame update
    void Awake() {
        instance = this;
        Initialize();
    }

    private void Initialize() {
        foreach (Transform child in mesh.transform) {
            _meshes.Add(child.name, child.GetComponent<MeshFilter>().sharedMesh);
        }
    }

    public Mesh GetCornerMesh(int bitmask, int level) {
        Mesh result;
        if (level > 1) {
            if (_meshes.TryGetValue(bitmask.ToString(), out result)) {
                return result;
            }
        }
        else if (level == 0) {
            if (_meshes.TryGetValue("0_" + bitmask, out result)) {
                return result;
            }
        } else if (level == 1) {
            if (_meshes.TryGetValue("1_" + bitmask, out result)) {
                return result;
            }
        }
        return null;
    }
}
