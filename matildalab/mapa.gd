extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var Rutas = $Rutas
@onready var SeguidorRuta = $SeguidorRuta
@onready var Avion = $SeguidorRuta/Avion 

########### VARIABLES GLOBALES ###########
var linea : Line2D
var puntos_totales : PackedVector2Array
var ultima_posicion : Vector2 
var duración_vuelo  = 5.0 # Duración del viaje en segundos
var tiempo = 0.0 # Acumulador de tiempo para el progreso

########### FUNCIONES ###########
"""
Obtiene el nombre de la cientifica a la que hay que ir ahora y obtiene la
ruta necesaria para llegar hasta ella. Actualiza la ultima posición del avión
a la nueva posición.
"""
func _ready():
	if MatildaLab.instancia.ruta_actual == "": return
	var ruta = Rutas.get_node("Ruta" + MatildaLab.instancia.ruta_actual) 	
	if ruta:
		var destino = ruta.get_node("MarcaDestino")
		destino.visible = true
		SeguidorRuta.reparent(ruta)
		ultima_posicion = SeguidorRuta.global_position
		configurar_linea(ruta)

"""
Crea una linea que marca la ruta que seguirá el avión y la añade
a la ruta, estableciendo su anchura, su textura, su estilo y 
su repetición, y por último y obtiene y establece una lista de puntos 
en la ruta para poder dibujar la línea correctamente.
"""
func configurar_linea(ruta: Path2D):
	linea = Line2D.new()
	ruta.add_child(linea)
	linea.width = 120.0 
	linea.texture = load("res://assets/linea.png")
	linea.texture_mode = Line2D.LINE_TEXTURE_TILE 
	linea.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	puntos_totales = ruta.curve.get_baked_points()
	linea.points = puntos_totales

"""
Incrementa el tiempo que lleva el vuelo y calcula el progreso para actualizar
el progress_ratio, el dibujo de la línea y la orientación del avión.
"""
func _process(delta):	
	tiempo += delta
	var progreso = tiempo/duración_vuelo
	SeguidorRuta.progress_ratio =  tiempo/duración_vuelo
	Avion.visible = true
	var punto_avion = int(progreso * puntos_totales.size())
	linea.points = puntos_totales.slice(punto_avion)
	var posicion_actual = SeguidorRuta.global_position
	var diferencia_x = posicion_actual.x - ultima_posicion.x
	if diferencia_x < -0.1:
		Avion.flip_h = true 
	elif diferencia_x > 0.1:
		Avion.flip_h = false 
	ultima_posicion = posicion_actual
	if progreso >= 1.0:
		terminar_vuelo()

"""
Cuando el avión llega al final de la ruta, espera un segundo
y pasa al siguiente minijuego.
"""
func terminar_vuelo():
	Avion.visible = false
	get_tree().create_timer(1.0).timeout
	MatildaLab.instancia.siguiente_minijuego()
