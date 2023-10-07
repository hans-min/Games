using UnityEngine;

public class Coord {
    public int x, y, z;

    public Coord(int setX, int setY, int setZ) {
        x = setX;
        y = setY;
        z = setZ;
    }
}

public class GridElement : MonoBehaviour {
    public Coord coord;
    private Collider _collider;
    private Renderer _renderer;
    private bool _isEnabled;
    private float _elementHeight;
    public Corner[] corners = new Corner[8];

    public void Initialize(int setX, int setY, int setZ, float elementHeight) {
        var width = LevelGenerator.instance.width;
        this._elementHeight = elementHeight;
        coord = new Coord(setX, setY, setZ);
        name = "GE_" + coord.x + "-" + coord.y + "-" + coord.z;
        this.transform.localScale = new Vector3(1.0f, elementHeight, 1.0f);
        _collider = GetComponent<Collider>();
        _renderer = GetComponent<Renderer>();

        var allCorners = LevelGenerator.instance.cornerElements;
        corners[0] = allCorners[coord.x + (width + 1) * (coord.z + (width + 1) * coord.y)];
        corners[1] = allCorners[coord.x + 1 + (width + 1) * (coord.z + (width + 1) * coord.y)];
        corners[2] = allCorners[coord.x + (width + 1) * (coord.z + 1 + (width + 1) * coord.y)];
        corners[3] = allCorners[coord.x + 1 + (width + 1) * (coord.z + 1 + (width + 1) * coord.y)];
        corners[4] = allCorners[coord.x + (width + 1) * (coord.z + (width + 1) * (coord.y + 1))];
        corners[5] = allCorners[coord.x + 1 +(width + 1) * (coord.z + (width + 1) * (coord.y + 1))];
        corners[6] = allCorners[coord.x + (width + 1) * (coord.z + 1 +(width + 1) * (coord.y + 1))];
        corners[7] = allCorners[coord.x + 1 +(width + 1) * (coord.z + 1 +(width + 1) * (coord.y + 1))];

        var bounds = _collider.bounds;
        var cbMin = bounds.min;
        var cbMax = bounds.max;
        corners[0].SetPosition(cbMin.x, cbMin.y, cbMin.z);
        corners[1].SetPosition(cbMax.x, cbMin.y, cbMin.z);
        corners[2].SetPosition(cbMin.x, cbMin.y, cbMax.z);
        corners[3].SetPosition(cbMax.x, cbMin.y, cbMax.z);
        corners[4].SetPosition(cbMin.x, cbMax.y, cbMin.z);
        corners[5].SetPosition(cbMax.x, cbMax.y, cbMin.z);
        corners[6].SetPosition(cbMin.x, cbMax.y, cbMax.z);
        corners[7].SetPosition(cbMax.x, cbMax.y, cbMax.z);
    }

    public Coord GetCoord() {
        return coord;
    }

    //show block
    public void SetEnabled() {
        _isEnabled = true;
        _collider.enabled = true;
        //_renderer.enabled = true;
        foreach (Corner corner in corners) {
            corner.SetCorner();
        }
    }

    //hide block
    public void SetDisabled() {
        _isEnabled = false;
        _collider.enabled = false;
        _renderer.enabled = false;
        foreach (Corner corner in corners) {
            corner.SetCorner();
        }
    }

    public bool GetEnabled() {
        return _isEnabled;
    }

    public float getHeight() {
        return _elementHeight;
    }
}