# res://gd/Debug.gd
# 注意:
# このスクリプトは「Autoload」としてのみ使用することを意図しています。
# いかなるノードにもアタッチしないでください。
extends Node

# 定数とプロパティ
var _label3d_path: String = "/root/Main/XROrigin3D/XRCamera3D/Debug"
var _label3d: Label3D = null
var _content: Array = [] # メッセージの履歴


# 初期化メソッド
func _ready():
	_label3d = get_node(_label3d_path)


# メッセージを追加して表示を更新
# message: 表示するメッセージ
func print(message: String):
	_content.append(message)
	if _content.size() > 10: # 最大表示行数
		_content.remove_at(0)
	_update_display()


# メッセージをクリアして表示を更新
func reset():
	_content.clear()
	_update_display()


# エラーメッセージを追加して表示を更新
# message: 表示するエラーメッセージ
func error(message: String):
	_content.append("Error: " + message)
	if _content.size() > 10: # 最大表示行数
		_content.remove_at(0)
	_update_display()


# 表示を更新
func _update_display():
	var display_text = ""
	for i in range(_content.size()):
		display_text += _content[i]
		if i < _content.size() - 1:
			display_text += "\n"
	if _content.size() > 0:
		display_text += " <" # 最後の行に " <" を追加
	_label3d.text = display_text
