extends HBoxContainer

const COG_PANEL := preload('res://objects/battle/battle_ui/cog_panel.tscn')


func assign_cogs(cogs: Array[Cog]):
	for cog in cogs:
		var new_panel := COG_PANEL.instantiate()
		
		add_child(new_panel)
		new_panel.set_cog(cog)

func reset(_gags):
	for child in get_children():
		child.queue_free()
