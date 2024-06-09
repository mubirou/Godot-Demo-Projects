# XROrigin3D/RightController/Debugger(Debugger.gd)
extends Label3D

var _content = []  # 内部で保持する内容

func _ready():
	pass

func reset():
	_content.clear()
	_update_display()

func print(arg: String):
	_content.append(arg)
	if _content.size() > 10:  # 最大表示行数
		_content.remove_at(0)
	_update_display()

func _update_display():
	var display_text = ""
	for i in range(_content.size()):
		display_text += _content[i]
		if i < _content.size() - 1:
			display_text += "\n"

	if _content.size() > 0:
		display_text += " ←"  # 最後の行に " ←" を追加

	text = display_text
