extends Control

# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
var firestore_collection : FirestoreCollection 
# ------------------------------------------------------------------------------ PRIVATE PROPERTIES
var session_id
# ------------------------------------------------------------------------------ BASIC METHODS

func _ready():
	Firebase.Auth.connect("signup_succeeded", _on_auth_done)
	Firebase.Auth.login_anonymous()
	ALTC.connect("game_over", _on_session_done)
	
	
func _on_auth_done(_one):
	session_id = _one["localid"]
	firestore_collection = Firebase.Firestore.collection('TestGameSessionCollection')
	#firestore_collection.get_doc("user")
	#var doc : FirestoreDocument = await firestore_collection.get_document
	#print("---")
	#print(doc)
	
#	doc["doc_name"] = "Faer"
#	firestore_collection.update("user", doc.document)
# ------------------------------------------------------------------------------ CUSTOM METHODS

func _on_session_done():
	var session_name = "Session_" + session_id
	firestore_collection.add(session_name, ALTC.get_data_dict())

# ------------------------------------------------------------------------------ SIGNALS


