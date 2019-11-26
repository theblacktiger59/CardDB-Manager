extends LineEdit
class_name ArgCustomString


func set_arg(s: String) -> void:
    text = s


func resolve() -> String:
    return text