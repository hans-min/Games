using System;
using UnityEngine;

public class CursorMovement : MonoBehaviour {
	RaycastHit _hit;
	Ray _ray;
	private RectTransform _rectTransform;

	private GridElement _lastHit;

	private void Start() {
		_rectTransform = this.GetComponent<RectTransform>();
		_rectTransform.sizeDelta = Vector2.zero;
	}

	// Update is called once per frame
	void Update () {
		_ray = Camera.main!.ScreenPointToRay(Input.mousePosition);

		if(Physics.Raycast(_ray, out _hit) && _hit.collider.CompareTag("gridElement"))
		{
			transform.position = _hit.collider.transform.position;
			_lastHit = _hit.collider.gameObject.GetComponent<GridElement>();
			_rectTransform.sizeDelta = new Vector2(1.0f, _lastHit.getHeight());
			//if right-click, remove element
			if (Input.GetMouseButtonDown(1)) {
				SetCursorButton(0);
			}
		}
	}

	//add a block depending on the input, which tell us where to add the block (U,R,L,D)
	public void SetCursorButton(int input) {
		var coord = _lastHit.coord;
		print(coord.x + "-" + coord.y + "-" + coord.z);
		var generator = LevelGenerator.instance;
		var width = generator.width;
		var height = generator.height;
		switch (input) {
			case 0:
				//can't delete the base
				if (coord.y > 0) {
					_lastHit.SetDisabled();
				}
				break;
			case 1:
				//add X+
				if (coord.x < width - 1) {
					generator.gridElements[coord.x + width * (coord.z + width * coord.y)+1].SetEnabled();
				}
				break;
			case 2:
				if (coord.x >0) {
					generator.gridElements[coord.x + width * (coord.z + width * coord.y)-1].SetEnabled();
				}
				break;
			case 3:
				//add Z+
				if (coord.z < width - 1) {
					generator.gridElements[coord.x + width * (coord.z + 1 + width * coord.y)].SetEnabled();
				}
				break;
			case 4:
				//add Z-
				if (coord.z > 0) {
					generator.gridElements[coord.x + width * (coord.z - 1 + width * coord.y)].SetEnabled();
				}
				break;
			case 5:
				//add Y+
				if (coord.y < height - 1) {
					generator.gridElements[coord.x + width * (coord.z + width * (coord.y + 1))].SetEnabled();
				}
				break;
		}
	}
}