extends CanvasLayer

@onready var Boton1 = $VBoxContainer/HBoxContainer/Boton1
@onready var Boton2 = $VBoxContainer/HBoxContainer/Boton2
@onready var Boton3 = $VBoxContainer/HBoxContainer/Boton3
@onready var Boton4 = $VBoxContainer/HBoxContainer/Boton4
@onready var Boton5 = $VBoxContainer/HBoxContainer/Boton5
@onready var AudioPregunta = $AudioPregunta

func _ready() -> void:
	var imagen_boton1 = Boton1.texture_normal.get_image()
	var mascara_boton1 = BitMap.new()
	mascara_boton1.create_from_image_alpha(imagen_boton1)
	Boton1.texture_click_mask = mascara_boton1
	var imagen_boton2 = Boton2.texture_normal.get_image()
	var mascara_boton2 = BitMap.new()
	mascara_boton2.create_from_image_alpha(imagen_boton2)
	Boton2.texture_click_mask = mascara_boton2
	var imagen_boton3 = Boton3.texture_normal.get_image()
	var mascara_boton3 = BitMap.new()
	mascara_boton3.create_from_image_alpha(imagen_boton3)
	Boton3.texture_click_mask = mascara_boton3
	var imagen_boton4 = Boton4.texture_normal.get_image()
	var mascara_boton4 = BitMap.new()
	mascara_boton4.create_from_image_alpha(imagen_boton4)
	Boton4.texture_click_mask = mascara_boton4
	var imagen_boton5 = Boton5.texture_normal.get_image()
	var mascara_boton5 = BitMap.new()
	mascara_boton5.create_from_image_alpha(imagen_boton5)
	Boton5.texture_click_mask = mascara_boton5
	AudioPregunta.play()

func _on_boton_1_pressed() -> void:
	MatildaLab.instancia.evaluacion = 5
	queue_free()
	
func _on_boton_2_pressed() -> void:
	MatildaLab.instancia.evaluacion = 4
	queue_free()

func _on_boton_3_pressed() -> void:
	MatildaLab.instancia.evaluacion = 3
	queue_free()
	
func _on_boton_4_pressed() -> void:
	MatildaLab.instancia.evaluacion = 2
	queue_free()

func _on_boton_5_pressed() -> void:
	MatildaLab.instancia.evaluacion = 1
	queue_free()
