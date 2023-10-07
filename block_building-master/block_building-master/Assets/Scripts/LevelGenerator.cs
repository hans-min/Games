using UnityEngine;

public class LevelGenerator : MonoBehaviour {
    public int width = 5;

    public int height = 10;

    public GridElement gridElement;
    GridElement[] gridElements;
    // Start is called before the first frame update
    void Start() {
        gridElements = new GridElement[width * width * height];
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                for (int z = 0; z < width; z++) {
                    GridElement gridInstance = Instantiate(gridElement, new Vector3(x, y, z), Quaternion.identity, transform);
                    gridInstance.name = gridInstance.name + " " + x + " " + y + " " + z; 
                    gridElements[x + width * (z + width * y)] = gridInstance;
                }
            }
        }
    }
}
