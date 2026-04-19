extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Animador = $Animador
@onready var FraseFinal = $Cientifica/Bocadillo/FraseFinal

########### FUNCIONES ###########
"""
Anima el final del minijuego, mostrando la pieza obtenida
"""
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	Animador.play("mostrar_pieza")
	FraseFinal.play()
	await Animador.animation_finished
	await get_tree().create_timer(1.0).timeout
	MatildaLab.instancia.terminar_minijuego()
