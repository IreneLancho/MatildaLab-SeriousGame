extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var FlechaArriba := $FlechaArriba
@onready var FlechaAbajo := $FlechaAbajo
@onready var FlechaIzquierda := $FlechaIzquierda
@onready var FlechaDerecha := $FlechaDerecha
 
########### FUNCIONES ###########
"""
Se crean máscaras para cada una de las flechas correspondiente con cada una
de las cuatro direcciones para que solo pueda hacerse clic en la forma 
concreta de la flecha
"""
func _ready():
	var imagen_arriba = FlechaArriba.texture_normal.get_image()
	var mascara_arriba = BitMap.new()
	mascara_arriba.create_from_image_alpha(imagen_arriba)
	FlechaArriba.texture_click_mask = mascara_arriba
	var imagen_abajo = FlechaAbajo.texture_normal.get_image()
	var mascara_abajo = BitMap.new()
	mascara_abajo.create_from_image_alpha(imagen_abajo)
	FlechaAbajo.texture_click_mask = mascara_abajo
	var imagen_izq = FlechaIzquierda.texture_normal.get_image()
	var mascara_izq = BitMap.new()
	mascara_izq.create_from_image_alpha(imagen_izq)
	FlechaIzquierda.texture_click_mask = mascara_izq
	var imagen_der = FlechaDerecha.texture_normal.get_image()
	var mascara_der = BitMap.new()
	mascara_der.create_from_image_alpha(imagen_der)
	FlechaDerecha.texture_click_mask = mascara_der

"""
Desactiva o activa la flecha hacia arriba en función del valor del parámetro desactivar
"""
func desactivar_arriba(desactivar: bool) -> void:
	FlechaArriba.disabled = desactivar

"""
Desactiva o activa la flecha hacia abajo en función del valor del parámetro desactivar
"""
func desactivar_abajo(desactivar: bool) -> void:
	FlechaAbajo.disabled = desactivar

"""
Desactiva o activa la flecha hacia la izquierda en función del valor del parámetro desactivar
"""
func desactivar_izquierda(desactivar: bool) -> void:
	FlechaIzquierda.disabled = desactivar

"""
Desactiva o activa la flecha hacia la derecha en función del valor del parámetro desactivar
"""
func desactivar_derecha(desactivar: bool) -> void:
	FlechaDerecha.disabled = desactivar

"""
Desactiva o activa la flechas en función del valor del parámetro desactivar
"""
func desactivar_flechas(desactivar: bool) -> void:
	desactivar_arriba(desactivar)
	desactivar_abajo(desactivar)
	desactivar_izquierda(desactivar)
	desactivar_derecha(desactivar)
