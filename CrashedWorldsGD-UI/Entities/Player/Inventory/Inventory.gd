extends CanvasLayer

 # ----------------------------------------------------------------------------- VARIABLES
@export var recipeBook : RecipeBook
var equipedIDX : int = -1

 # ----------------------------------------------------------------------------- BASIC METHODS

func _ready():	
	resetInventory()
	populateCrafts()
	

func _input(event):
	if event.is_action_pressed("Interact"):
		ShowInventory(!$Margin.visible)

 # ----------------------------------------------------------------------------- INVENTORY FUNCTIONS
func populateCrafts():
	%CraftList.clear()
	var idx : int = 0
	for recipe in recipeBook.recipes:
		%CraftList.add_item(recipe.outputItem.item.itemName, recipe.outputItem.item.icon)
		%CraftList.set_item_metadata(idx, recipe)
		idx += 1
	
	for i in $ToDoList/Body.get_children():
		i.get_node("PinBox").connect("keyPressed", do_recipe)

func addItem(item : ItemHolder):
	item = item.duplicate(true)
	# If already in
	for i in range(0, %InvList.item_count):
		if item.item.itemName == %InvList.get_item_metadata(i).item.itemName:
			var amount = %InvList.get_item_metadata(i).quantity + item.quantity
			%InvList.get_item_metadata(i).quantity = amount
			refreshList()
			ALTC.player_item_collected += 1
			return
	# else
	var text = item.item.itemName
	var idx = %InvList.add_item(text, item.item.icon)
	%InvList.set_item_metadata(idx, item)
	refreshList()
	ALTC.player_item_collected += 1

func buyItem(item : ItemHolder, amount : int) -> bool:
	for i in range(0, %InvList.item_count):
		if item.item.itemName == %InvList.get_item_metadata(i).item.itemName:
			if %InvList.get_item_metadata(i).quantity - amount >= 0:
				%InvList.get_item_metadata(i).quantity -= amount
				
				if %InvList.get_item_metadata(i).quantity == 0: 
					if i == equipedIDX : equipedIDX = -1
					%InvList.remove_item(i)
					$Craft.play()

				refreshList()
				return true
	return false

func do_recipe(pinbox : Pinbox):
	for i in pinbox.current_recipe.inputItems:
		if !buyItem(i, i.quantity):
			return false
	addItem(pinbox.current_recipe.outputItem)
	pinbox.get_parent().hide()
	pinbox.current_recipe = null
	ALTC.player_craft_done += 1

func get_item_amount(item : ItemHolder) -> int:
	for i in range(0, %InvList.item_count):
		if item.item.itemName == %InvList.get_item_metadata(i).item.itemName:
			return %InvList.get_item_metadata(i).quantity
	return 0

# -----------------------------------------------------------------------------  HELPER FUNCTIONS

func resetInventory(): %InvList.clear()

func ShowInventory(value : bool):
	$Margin.visible = value
	if value:
		%InvList.grab_focus()
		$ToDoList.modulate.a = 0.5
	else:
		%InvList.release_focus()
		$ToDoList.modulate.a = 1

func refreshList():
	for i in range(0, %InvList.item_count):
		var meta : ItemHolder = %InvList.get_item_metadata(i)
		var text = meta.item.itemName
		
		if meta.quantity != 1 : 
			text += " (" + str(meta.quantity) + ")"

		if i == equipedIDX :
			text += " (EQUIPED)"
			
		%InvList.set_item_text(i, text)
		%InvList.set_item_tooltip_enabled(i, true)
		%InvList.set_item_tooltip(i-1, meta.item.description) # i-1 for some reason

# ------------------------------------------------------------------------------ SIGNALS
func _on_craft_list_item_selected(index):
	$Margin/HSep/RecipeBox/RecipeNode.visible = true
	var metadata : Recipe = %CraftList.get_item_metadata(index)
	$Margin/HSep/RecipeBox/RecipeNode.set_recipe(metadata)



func _on_tab_bar_tab_clicked(tab):
	if tab == 0: 
		%InvList.visible = true
		%CraftList.visible = false
		$Margin/HSep/RecipeBox.visible = false
		$Margin/HSep/Infos.visible = true
		%InvList.deselect_all()
		%CraftList.deselect_all()
	if tab == 1:
		%InvList.visible = false
		%CraftList.visible = true
		$Margin/HSep/RecipeBox.visible = true
		$Margin/HSep/Infos.visible = false
		$Margin/HSep/RecipeBox/RecipeNode.visible = false
		%InvList.deselect_all()
		%CraftList.deselect_all()

func _on_recipe_node_recipe_clicked(recipe : Recipe):
	for i in $ToDoList/Body.get_children():
		if i.get_node("PinBox").current_recipe == null:
			i.get_node("PinBox").set_recipe(recipe)
			i.visible = true
			return
	return
			

func _on_equipe_pressed():
	if %InvList.get_selected_items().size() > 0:
		var select = %InvList.get_selected_items()[0]
		var selectMeta : ItemHolder = %InvList.get_item_metadata(select)
			
		if selectMeta.item.canBeEquiped == true && equipedIDX != select:
			get_parent().equip(selectMeta)
			equipedIDX = select
		refreshList()

func _on_unequipe_pressed():
	get_parent().equip(null)
	equipedIDX = -1
	refreshList()

func _on_inv_list_item_clicked(index, _at_position, mouse_button_index):
	var itemholder : ItemHolder = %InvList.get_item_metadata(index)
	
	# Upgrade ? 
	var upgradeNode = $Margin/HSep/Infos/VBoxContainer/Recipes
	upgradeNode.visible = false
	for i in upgradeNode.get_children():
		i.visible = false
	
	if itemholder.item.upgrades.size() > 0 : 
		upgradeNode.visible = true
		for i in range(0, itemholder.item.upgrades.size()):
			upgradeNode.get_child(i).set_recipe(itemholder.item.upgrades[i])
			upgradeNode.get_child(i).visible = true
	
	if mouse_button_index == 2:
		_on_equipe_pressed()
