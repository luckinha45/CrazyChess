#warning-ignore-all:UNUSED_ARGUMENT

extends Sprite

onready var Global = get_node("/root/Global")
var can_drag = false

onready var originalPos = position

enum side { BLACK, WHITE }
export(side) var team

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_drag = event.pressed
		if !can_drag:
			z_index = 0
			var pos = Vector2()
			pos.x = round(get_global_mouse_position().x / Global.tileSize) * Global.tileSize
			pos.y = round(get_global_mouse_position().y / Global.tileSize) * Global.tileSize

			if pos.x < 60:
				pos.x = 60
			elif pos.x > 480:
				pos.x = 480
			
			if pos.y < 60:
				pos.y = 60
			elif pos.y > 480:
				pos.y = 480
			
			position = pos

			# VERIFICAR SE HA OUTRA PEÇA NA AREA
			var overlaps = get_node("Area2D").get_overlapping_areas()
			if !overlaps.empty():
				if name == Global.holdedPiece:
					var piece = overlaps[0].get_parent()

					if team != piece.team:
						print(piece.name)
						piece.queue_free()
					else:
						position = originalPos
			
			originalPos = position
		else:
			z_index = 1
			

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_drag:
		position = get_global_mouse_position()
		Global.holdedPiece = name
