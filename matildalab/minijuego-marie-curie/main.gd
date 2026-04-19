extends Node2D

########### REFERENCIAS A LOS NODOS ###########
@onready var MusicaFondo = $Sonidos/MusicaFondo
@onready var Minijuego = $Minijuego
@onready var Recipiente = $Minijuego/Materiales/Recipiente
@onready var BotonAyuda = $Minijuego/Interfaz/BotonAyuda

########### VARIABLES GLOBALES ###########
@onready var materiales := [$Minijuego/Materiales/Material5, $Minijuego/Materiales/Material3, $Minijuego/Materiales/Material1, $Minijuego/Materiales/Material7] # materiales que hay que echar en orden
var material_actual := 0 # material que hay que echar actualmente
var total_materiales := 4 # numero total de materiales que hay que echar para ganar
var juego_iniciado := false # indica si el juego ha sido iniciado previamente o no

########### FUNCIONES ###########
"""
Si estamos empezando el minijuego por primera vez, esta función lo iniciará
"""
func iniciar_juego() -> void:
	BotonAyuda.disabled = false
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		juego_iniciado = true
		MusicaFondo.play();

"""
Esta función se llama cuando se suelta un material que estaba siendo arrastrado. Si 
dicho material se ha soltado sobre un material que no es el recipiente o no se ha soltado
sobre ningún material, lo devuelve a su posición inicial. En caso contrario, se comprueba 
si el material arrastrado es el correcto, y en caso afirmativo, se avanza al siguiente
material y se comprueba si se han volcado correctamente todos los materiales. En ese caso,
el minijuego termina. Si no se ha arrastrado el material correcto al destino se anima el fallo.
"""
func _on_material_soltado(material_arrastrado: Variant, material_tocado: Variant) -> void:
	if material_tocado == null or material_tocado != Recipiente: 
		material_arrastrado.global_position = material_arrastrado.posicion_inicial 
		return
		
	if material_arrastrado == materiales[material_actual]: 
		material_arrastrado.animar_acierto() 
		material_actual = material_actual + 1 
		if material_actual == total_materiales: 
			await get_tree().create_timer(2.0).timeout
			terminar_minijuego()
	else: 
		MatildaLab.instancia.registrar_dato("Marie Curie", "fallos", 1)
		material_arrastrado.animar_fallo() 
	

"""
Esta función se llama cuando se pulsa el botón de ayuda y desactiva
este mismo botón.
"""
func _on_boton_ayuda_pressed() -> void:
	BotonAyuda.disabled = true
		
"""
Hace que la música vaya desapareciendo poco a poco y sustituye la escena del minijuego 
por la escena de fin de minijuego, manteniendo el fondo y la música.
"""	
func terminar_minijuego():
	MatildaLab.instancia.registrar_dato("Marie Curie", "tiempo", Time.get_ticks_msec())
	var tween = create_tween()
	tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
	var escena_fin = load("res://minijuego-marie-curie/fin_minijuego.tscn").instantiate()
	Minijuego.queue_free()
	add_child(escena_fin)
