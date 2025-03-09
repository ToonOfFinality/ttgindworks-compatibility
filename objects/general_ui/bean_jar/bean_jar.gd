extends Control

## Config
@export var bean_count := 0:
	set(x):
		if not is_node_ready():
			await ready
		bean_count = x
		_set_text(str(x))

## Child References
@onready var count_label := $Jar/BeanCount
@onready var start_scale: Vector2 = scale

var tween: Tween:
	set(x):
		if tween and tween.is_valid():
			tween.kill()
		tween = x

func _ready() -> void:
	_set_text(str(bean_count))

func _set_text(text: String) -> void:
	if count_label:
		count_label.set_text(text)

func scale_pop() -> void:
	tween = Sequence.new([
		LerpProperty.new(self, ^"scale", 0.2, start_scale * 1.2).interp(Tween.EASE_OUT),
		LerpProperty.new(self, ^"scale", 0.2, start_scale * 1.0).interp(Tween.EASE_IN),
	]).as_tween(self)
