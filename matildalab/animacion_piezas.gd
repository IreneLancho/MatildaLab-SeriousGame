extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Animador = $Animador

########### FUNCIONES ###########
"""
Realiza la animación de distribuir las piezas por el mapa
"""
func _ready() -> void:
	Animador.play("mostrar_plano")
	await Animador.animation_finished
	Animador.play("distribuir_piezas")
	await Animador.animation_finished
	MatildaLab.instancia.siguiente_ruta()
