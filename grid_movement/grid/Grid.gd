extends TileMap

enum CellType { ACTOR, OBSTACLE, OBJECT, WALL, WALKABLE_WALL,  }

export(NodePath) var dialogue_ui

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)


func get_cell_pawn(cell, type = CellType.ACTOR):
	for node in get_children():
		if node.type != type:
			continue
		if world_to_map(node.position) == cell:
			return(node)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction

	var cell_tile_id = get_cellv(cell_target)
	
# This is how we can make movement only go up OR down
#	if direction.x != 0 and direction.y != 0:
#		return
# end up OR down code
# This is to allow diagonal movement, but not allow moving through
	if direction.x != 0 and direction.y != 0:
		print("we are considering diagonal movement")
		var diag_id_y = get_cellv(cell_start + Vector2(0,direction.y) )
		var diag_id_x = get_cellv(cell_start + Vector2(direction.x, 0) )
		if diag_id_x == -1 or diag_id_y == -1:
			print("we can pass this diagonal!")
		else:
			print("we cannot pass this diagonal")
			return
# end diag
	print("cell type is: %s" % cell_tile_id)
	match cell_tile_id:
		-1,CellType.WALKABLE_WALL,3,11,10,9:
			set_cellv(cell_target, CellType.ACTOR)
			set_cellv(cell_start, -1)
			return map_to_world(cell_target) + cell_size / 2
		CellType.OBJECT, CellType.ACTOR:
			var target_pawn = get_cell_pawn(cell_target, cell_tile_id)
			print("Cell %s contains %s" % [cell_target, target_pawn.name])

			if not target_pawn.has_node("DialoguePlayer"):
				return
			var t = get_node(dialogue_ui)
			print("I am here, dialogue_ui: %s" % dialogue_ui)
			print("%s" % t)
			dialogue_ui	= "Player/Camera2D2/DialogueUI"
			get_node(dialogue_ui).show_dialogue(pawn, target_pawn.get_node("DialoguePlayer"))
