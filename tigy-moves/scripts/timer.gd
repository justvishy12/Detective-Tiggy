extends Label

var running := false
var elapsed := 0.0

func _process(delta: float) -> void:
	if running:
		elapsed += delta
		var seconds = int(elapsed)
		var milliseconds = int((elapsed - seconds) * 100)
		text = "%02d:%02d" % [seconds, milliseconds]
		
func start_timer():
	running = true

func stop_timer():
	running = false
