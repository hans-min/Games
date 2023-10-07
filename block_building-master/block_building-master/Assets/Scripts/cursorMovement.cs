using UnityEngine;

public class cursorMovement : MonoBehaviour {
    private RaycastHit hit;

    private Ray ray;

    // Update is called once per frame
    void Update() {
        ray = Camera.main!.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit) && hit.collider.CompareTag("gridElement")) {
            transform.position = hit.collider.transform.position;
            Debug.Log(hit.collider.name);
        }
    }
}
