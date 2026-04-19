extends Area2D

@export var colores: Array[Texture2D] = [] # definimos un array con las diferentes texturas para cada obstáculo

func _ready() -> void:
	$Sprite2D.texture = colores.pick_random() # elegimos un color aleatorio del obstáculo
	collision_layer = 2 # establecemos la capa de colisión a 2 para que la buceadora pueda chocarse con él
	collision_mask = 1 # establecemos la máscara de colisión a 1 para que pueda ver a la buceadora
	connect("body_entered", Callable(self, "_on_body_entered")) # conectamos la señal de cuando un cuerpo entra en el collision shape con un método propio

func moverse(delta: float, velocidad: float) -> void:
		position.x -= velocidad*delta # desplazamos el obstáculo a la izquierda en función de la velocidad
		if position.x < -200: queue_free() # si se ha salido suficiente del viewport lo eliminamos

func _on_body_entered(body: Node2D) -> void:
	body.recibir_colision() # avisamos a la buceadora para que reciba la colisión
	queue_free() # eliminamos el obstáculo
