@tool
extends UIPanel

@onready var achievement_template := $AchievementTemplate
@onready var achievement_container: GridContainer = %AchievementContainer

func _ready() -> void:
	super()
	populate_achievements()

func populate_achievements() -> void:
	var achievements := SaveFileService.progress_file.active_achievements
	
	for achievement : Achievement in achievements:
		var new_element : Control
		if achievement.get_completed():
			new_element = create_achievement(achievement)
		else:
			new_element = create_achievement_template()
		achievement_container.add_child(new_element)

func create_achievement_template() -> Control:
	var new_achievement := achievement_template.duplicate()
	new_achievement.show()
	return new_achievement

func create_achievement(achievement : Achievement) -> Control:
	var new_achievement := create_achievement_template()
	new_achievement.get_node('Elements/Title').set_text(achievement.achievement_name)
	if achievement.achievement_icon:
		new_achievement.get_node('Elements/Icon').set_texture(achievement.achievement_icon)
	new_achievement.get_node('Elements/Summary').set_text(achievement.achievement_summary)
	return new_achievement
