extends Area3D

@export var itemToCheck : ItemHolder
var sendAnalytics : bool = true
@export var amountNeed: int = 5

func _ready():
		get_parent().get_parent().get_parent().global_position = Vector3(GameOptions.worldSize / 2.0, 1, GameOptions.worldSize / 2.0)

func _on_body_entered(body:Node3D) -> void:
	if body.is_in_group("player"):
		#check inventory
		var inventory : CanvasLayer = body.get_node("Inventory")
		var itemCounter = inventory.get_item_amount(itemToCheck)

		$Label.show()

		if itemCounter >= amountNeed:
			$Label.text = "You escaped!"
			ALTC.world_escaped = true
			ALTC.world_time_played = Time.get_ticks_msec() - ALTC.world_time_played
			SceneManager.isWon = true
			if sendAnalytics:
				sendAnalytics = false
				ALTC.game_over.emit()
			SceneManager.player.goToEndScreen()
		else:
			$Label.text = "You need " + str(amountNeed) + " Space Fluid to escape! Current amount: " + str(itemCounter)

		await get_tree().create_timer(3.0).timeout
		$Label.hide()
