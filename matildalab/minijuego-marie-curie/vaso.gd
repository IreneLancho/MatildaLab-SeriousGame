extends Area2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Sprite = $Sprite2D

########### VARIABLES GLOBALES ###########
@onready var liquidos := [ # variable que contiene los sprites intermedios del recipiente al que se van echando líquidos
	preload("res://minijuego-marie-curie/assets/liquido1.png"), 
	preload("res://minijuego-marie-curie/assets/liquido2.png"),
	preload("res://minijuego-marie-curie/assets/liquido3.png"),
	preload("res://minijuego-marie-curie/assets/liquido4.png")
]
var liquido_actual := 0 # líquido que se va a echar

########### FUNCIONES ###########
"""
Esta función se llama durante la animación de volcado (acierto) del material
sobre el recipiente. Actualiza la textura del recipiente y avanza a la siguiente.
"""
func llenarse() -> void:
	Sprite.texture = liquidos[liquido_actual] 
	liquido_actual = liquido_actual + 1 
