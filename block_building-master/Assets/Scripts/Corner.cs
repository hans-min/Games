using UnityEngine;

public class Corner : MonoBehaviour {
    private Coord _coord;
    public int bitMaskValue;
    private MeshFilter _meshFilter;
    public GridElement[] nearGridElements = new GridElement[8];
    public void Initialize(int x, int y, int z) {
        _coord = new Coord(x, y, z);
        name = "Corner " + _coord.x + "-" + _coord.y + "-" + _coord.z;
        _meshFilter = this.GetComponent<MeshFilter>();
        
    }

    public void SetCorner() {
        bitMaskValue = BitMask.GetBitMask(nearGridElements);
        _meshFilter.mesh = CornerMesh.instance.GetCornerMesh(bitMaskValue, _coord.y);
    }

    public void SetPosition(float setX, float setY, float setZ) {
        transform.position = new Vector3(setX, setY, setZ);
    }

    public void SetNearGridElements() {
        var width = LevelGenerator.instance.width;
        var height = LevelGenerator.instance.height;
        var allGridElements = LevelGenerator.instance.gridElements;
        //UpperNorthEast
        if (_coord.x < width && _coord.y < height && _coord.z < width) {
            nearGridElements[0] =
                allGridElements[_coord.x + width * (_coord.z + width * _coord.y)];
        }
        //UpperNorthWest
        if (_coord.x > 0 && _coord.y < height && _coord.z < width) {
            nearGridElements[1] =
                allGridElements[_coord.x - 1 + width * (_coord.z + width * _coord.y)];
        }
        //UpperSouthEast
        if (_coord.x > 0 && _coord.y < height && _coord.z > 0) {
            nearGridElements[2] =
                allGridElements[_coord.x - 1 + width * (_coord.z - 1 + width * _coord.y)];
        }
        //UpperSouthWest
        if (_coord.x < width && _coord.y < height && _coord.z > 0) {
            nearGridElements[3] =
                allGridElements[_coord.x + width * (_coord.z - 1 + width * _coord.y)];
        }
        
        //LowerNorthEast
        if (_coord.x < width && _coord.y > 0 && _coord.z < width) {
            nearGridElements[4] =
                allGridElements[_coord.x + width * (_coord.z + width * (_coord.y - 1))];
        }
        //LowerNorthWest
        if (_coord.x > 0 && _coord.y > 0 && _coord.z < width) {
            nearGridElements[5] =
                allGridElements[_coord.x - 1 + width * (_coord.z + width * (_coord.y - 1))];
        }
        //LowerSouthEast
        if (_coord.x > 0 && _coord.y > 0 && _coord.z > 0) {
            nearGridElements[6] =
                allGridElements[_coord.x - 1 + width * (_coord.z - 1 + width * (_coord.y - 1))];
        }
        //LowerSouthWest
        if (_coord.x < width && _coord.y > 0 && _coord.z > 0) {
            nearGridElements[7] =
                allGridElements[_coord.x + width * (_coord.z - 1 + width * (_coord.y - 1))];
        }
    }
}
