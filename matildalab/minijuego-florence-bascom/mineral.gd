extends Button

########### REFERENCIAS A LOS NODOS ###########
@onready var Animador = $Animador

########### REFERENCIAS A LOS NODOS ###########
enum Minerales {esmeralda,amatista,zafiro,pirita} # Define los cuatro tipos de minerales
@export var id_mineral: Minerales # Variable para seleccionar desde el inspector el tipo de mineral                                 
var revelado: bool = false # Indica si el mineral está visible
var emparejado: bool = false # Indica si el mineral ha sido emparejado correctamente
var puede_revelarse: bool = false # Indica si un mineral puede darse revelarse (si no está bloqueado por la animación)
signal mineral_volteado(mineral : Node) # Señal para avisar de que un mineral ha sido dado la vuelta


########### FUNCIONES ###########
"""
Espera durante 5 segundos para que se pueda memorizar el mineral, para posteriormente
esconderlo y permitir que pueda ser revelado al hacerse clic
"""
func iniciar_juego():
	await get_tree().create_timer(5.0).timeout 
	Animador.play("esconder")
	await Animador.animation_finished
	puede_revelarse = true 

"""
Esta función se llama cuando se hace clic en una roca para revelar el mineral que está
detrás. Si dicho mineral no está yarevelado, ni emparejado y puede revelarse,
se revela el mineral y se emite la señal correspondiente.
"""	
func _on_pressed() -> void: 
	if revelado or emparejado or not puede_revelarse: return
	revelado = true 
	Animador.play("revelar") 
	emit_signal("mineral_volteado", self)
	
"""
Esconde el mineral 
"""
func esconder(): 
	revelado = false 
	Animador.play("esconder") 

"""
Desactiva el mineral y lo hace invisible
"""	
func borrar_mineral() -> void: 
	Animador.stop() 
	self.modulate = 0 
	disabled = true

"""
Anima el mineral cuando se empareja correctamente
"""
func animar_acierto(): 
	Animador.play("acierto") 
	
"""
Anima el mineral cuando se empareja incorrectamente
"""
func animar_fallo(): 
	Animador.play("fallo") 
	
"""
Impide que se pueda revelar el mineral
"""
func _on_parar_vueltas(): 
	puede_revelarse = false 

"""
Permite que se pueda revelar el mineral
"""
func _on_continuar_vueltas(): 
	puede_revelarse = true 
	
"""
Devuelve el nombre del mineral para que Florence pueda decirlo
"""
func nombre_mineral():
	return Minerales.keys()[self.id_mineral]
