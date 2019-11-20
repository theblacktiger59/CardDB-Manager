extends SpinBox
class_name ArgNumber


func set_arg(v: float) -> void:
    value = v


func resolve() -> float:
    return value