using UnityEngine;

public class LevelGenerator : MonoBehaviour {
    public static LevelGenerator instance;
    public int width = 5;
    public int height = 10;
    public GridElement gridElementPrefab;
    public Corner cornerPrefab;

    public GridElement[] gridElements;
    public Corner[] cornerElements;

    private float floorHeight = 0.25f, 
        basementHeight = 1.5f - 0.25f / 2;


    void Start() {
        instance = this;
        gridElements = new GridElement[width * width * height];
        cornerElements = new Corner[(width + 1) * (width + 1) * (height + 1)];
        
        for (var y = 0; y < height + 1; y++) {
            for (var x = 0; x < width + 1; x++) {
                for (var z = 0; z < width + 1; z++) {
                    var cornerElementInstance = Instantiate(
                        cornerPrefab, Vector3.zero, Quaternion.identity, transform);
                    cornerElementInstance.Initialize(x, y, z);
                    cornerElements[x + (width + 1) * (z + (width + 1) * y)] = cornerElementInstance;
                }
            }
        }

        for (var y = 0; y < height; y++) {
            float yPos = y;
            float elementHeight;
            if (y == 0) {
                elementHeight = floorHeight;
            }
            else if (y == 1) {
                elementHeight = basementHeight;
                yPos = floorHeight / 2 + basementHeight / 2;
            }
            else {
                elementHeight = 1;
            }
            for (var x = 0; x < width; x++) {
                for (var z = 0; z < width; z++) {
                    var gridElementInstance = Instantiate(
                        gridElementPrefab, new Vector3(x, yPos, z), 
                        Quaternion.identity, transform);
                    gridElementInstance.Initialize(x, y, z, elementHeight);
                    
                    gridElements[x + width * (z + width * y)] = gridElementInstance;
                }
            }
        }

        foreach (var corner in cornerElements) {
            corner.SetNearGridElements();
        }

        foreach (GridElement gridElement in gridElements) {
            gridElement.SetEnabled();
        }
    }
}