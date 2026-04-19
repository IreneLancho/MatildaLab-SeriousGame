extends Control

########### REFERENCIAS A LOS NODOS ###########
@onready var Minerales = $Minijuego/Minerales
@onready var Florence = $Minijuego/Interfaz/Florence
@onready var BotonAyuda = $Minijuego/Interfaz/BotonAyuda
@onready var MusicaFondo = $MusicaFondo
@onready var Minijuego = $Minijuego

########### VARIABLES GLOBALES ###########
var minerales_seleccionados : Array = [] # Array que contiene los minerales que están seleccionados
var juego_iniciado = false # Indica si el juego ha sido iniciado

########### SEÑALES ###########
signal parar_vueltas() # Impide que se sigan dando la vuelta más minerales
signal continuar_vueltas() # Permite que se sigan dando la vuelta más mienerales

########### FUNCIONES ###########
"""
Si estamos empezando el minijuego por primera vez, esta función lo iniciará
conectando las señales de cada mineral para que avisen al main cuando sean volteados,
además de distribuirlos de forma aleatoria e iniciar a cada uno de ellos individualemnte.
Por último, pausa el minijuego durante unos segundos para que puedan memorizarse las 
parejas de minerales.
"""
func iniciar_juego():
	if not juego_iniciado:
		MatildaLab.instancia.iniciar_tiempo()
		BotonAyuda.disabled = true
		MusicaFondo.play()
		juego_iniciado = true
		for mineral in Minerales.get_children(): 
			mineral.connect("mineral_volteado", Callable(self, "_on_mineral_volteado")) 
			parar_vueltas.connect(mineral._on_parar_vueltas) 
			continuar_vueltas.connect(mineral._on_continuar_vueltas) 
		barajar() 
		for mineral in Minerales.get_children():
			mineral.iniciar_juego()
		await get_tree().create_timer(5.5).timeout
		BotonAyuda.disabled = false

"""
Distribuye aleatoriamente los minerales en el Grid (Minerales)
"""
func barajar(): 
	var minerales = Minerales.get_children() 
	minerales.shuffle() 
	for i in range(minerales.size()): 
		Minerales.move_child(minerales[i], i)

"""
Esta función se llama cuando un mineral ha sido volteado. Si el mineral volteado no está seleccionado ya,
se añade este mineral a la lista de seleccionados. Posteriormente, se comprueba si se ha seleccionado
ya una pareja y en caso afirmativo impedimos que se puedan voltear más minerales. Por último, comprobamos
si es correcta la pareja.
"""
func _on_mineral_volteado(mineral):
	if mineral in minerales_seleccionados: return
	minerales_seleccionados.append(mineral)
	if minerales_seleccionados.size() == 2:
		emit_signal("parar_vueltas") 
		comprobar_pareja() 

"""
Compara la pareja de minerales seleccionada. En caso de ser del mismo tipo, se anima
el acierto y la aparición de la científica diciendo qué mineral es el de esta pareja. 
Después, se borra la pareja y se permite que se sigan volteando minerales, además de 
comprobar si ya hemos emparejado todos. En caso de fallo, se anima el error, se permite 
que se sigan volteando mienrales y se vuelven a esconder estos minerales seleccionados.
Por último se vacía el array de minerales seleccionados.
"""
func comprobar_pareja():
	var m1 = minerales_seleccionados[0] 
	var m2 = minerales_seleccionados[1] 
	if m1.id_mineral == m2.id_mineral: 
		m1.animar_acierto()
		m2.animar_acierto()
		Florence.aparecer(m1.nombre_mineral())
		await get_tree().create_timer(4.5).timeout
		m1.emparejado = true 
		m2.emparejado = true 
		m1.borrar_mineral() 
		m2.borrar_mineral() 
		emit_signal("continuar_vueltas") 
		comprobar_victoria() 
	else:
		MatildaLab.instancia.registrar_dato("Florence", "fallos", 1)
		m1.animar_fallo()
		m2.animar_fallo()
		await m2.get_node("Animador").animation_finished
		m1.esconder() 
		m2.esconder() 
		await m2.get_node("Animador").animation_finished
		emit_signal("continuar_vueltas") 
	minerales_seleccionados.clear() 

"""
Comprueba que se hayan emparejado todos los minerales. En caso afirmativo, 
terminamos el minijuego.
"""
func comprobar_victoria():
	var todos_emparejados = true
	for mineral in Minerales.get_children(): 
		if not mineral.emparejado: 
			todos_emparejados = false 
			break
	if todos_emparejados: terminar_minijuego()

"""
Hace que la música vaya desapareciendo poco a poco y sustituye la escena del minijuego 
por la escena de fin de minijuego, manteniendo el fondo y la música.
"""	
func terminar_minijuego():
	MatildaLab.instancia.registrar_dato("Florence", "tiempo", Time.get_ticks_msec())
	var tween = create_tween()
	tween.tween_property(MusicaFondo, "volume_db", -80.0, 2.5)
	var escena_fin = load("res://minijuego-florence-bascom/fin_minijuego.tscn").instantiate()
	Minijuego.queue_free()
	add_child(escena_fin)
	
