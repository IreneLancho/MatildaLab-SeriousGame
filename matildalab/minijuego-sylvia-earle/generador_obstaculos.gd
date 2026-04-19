extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var TemporizadorObstaculo = $TemporizadorObstaculo

########### VARIABLES GLOBALES ###########
@export var obstaculos: Array[PackedScene] = [] # creamos un array escenas para añadir los dos tipos de obstáculos: peces y corales
@export var buceadora: CharacterBody2D # referencia a sylvia
var carriles := [225,575,925] # posiciones en la que aparecen los obstáculos en los carriles
var tiempo := 7 # tiempo en el que se genera un nuevo obstáculo

########### FUNCIONES ###########
"""
Cuando se inicia el minijuego, empieza el temporizador de generación de obstáculos
con un valor de 2 segundos y guarda una referencia al main.
"""
func iniciar_juego(main: Node2D) -> void:
	TemporizadorObstaculo.start(2.0) 

"""
Esta función se llama cuando se termina el temporizador de generación de obstáculos.
Se establece el tiempo del temporizador al valor indicado en la variable tiempo. 
Posteriormente, se obtiene el carril de la buceadora para generar un obstáculo en 
dicho carril. En función de este carril, se obtiene el tipo de obstáculo (coral o peces) 
que se va a generar, para instanciarlo posteriormente y ajustar sus coordenadas 
para que entre por el borde derecho de la pantaña. Por último, se añade el obstáculo 
y se actualiza el tiempo del temporizador para que cada vez salgan los obstáculos con 
mayor frecuencia.
"""
func _on_timer_timeout() -> void:
	TemporizadorObstaculo.start(tiempo) 
	var carril_objetivo = buceadora.carril
	var tipo_obstaculo 
	if carril_objetivo == 2: tipo_obstaculo = 1  
	else: tipo_obstaculo = 0 
	var escena = obstaculos[tipo_obstaculo]
	var obstaculo = escena.instantiate() 
	obstaculo.position.y = carriles[carril_objetivo] 
	obstaculo.position.x = get_viewport_rect().size.x + 200 
	add_child(obstaculo)
	tiempo = max(tiempo-0.5,3)  

"""
Para cada obstáculo, si este tiene un método moverse (no es el temporizador),
hace que se muevan en función de la velocidad actual
"""
func mover_obstaculos(delta: float, velocidad:float) -> void:
	for obstaculo in get_children(): 
		if obstaculo.has_method("moverse"): 
			obstaculo.moverse(delta, velocidad) 


"""
Cuando el juego está en pausa se pausa temporalmente el temporizador
de generación de obstáculos
"""
func parar_juego() -> void:
	TemporizadorObstaculo.paused = true

"""
Cuando el juego ha dejado de estar en pausa se retoma el temporizador
de generación de obstáculos
"""	
func continuar_juego() -> void:
	TemporizadorObstaculo.paused = false
