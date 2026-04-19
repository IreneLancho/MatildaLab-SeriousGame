extends Node
class_name MatildaLab  

########### REFERENCIAS A NODOS ###########
@onready var Animaciones = $Interfaz/Animaciones
@onready var Inicio = $Interfaz/Inicio
@onready var Fin = $Interfaz/Fin
@onready var BotonPlay = $Interfaz/BotonPlay
@onready var BotonSalir = $Interfaz/BotonSalir
@onready var BotonCerrar = $Interfaz/BotonCerrar
@onready var DialogoCerrar = $Interfaz/DialogoCerrar
@onready var Escena = $Escena
@onready var BaseDeDatos = $BaseDeDatos
@onready var Sonidos = $Sonidos
@onready var BotonCreditos = $Interfaz/BotonCreditos
@onready var Creditos = $Interfaz/Creditos

########### VARIABLES GLOBALES ###########
# Lista que une cada escena de minijuego con la ruta que debe seguir en el mapa
var minijuegos = [
	{"escena": "res://minijuego-florence-bascom/main.tscn", "ruta": "Sylvia", "animacion": "res://minijuego-florence-bascom/videos/IntroFlorence.ogv"},
	{"escena": "res://minijuego-sylvia-earle/main.tscn", "ruta": "Valentina", "animacion": "res://minijuego-sylvia-earle/videos/IntroSylvia.ogv"},
	{"escena": "res://minijuego-valentina-tereshkova/main.tscn", "ruta": "MarieCurie", "animacion": "res://minijuego-valentina-tereshkova/videos/IntroValentina.ogv" },
	{"escena": "res://minijuego-marie-curie/main.tscn", "ruta": "MaryAgnes", "animacion": "res://minijuego-marie-curie/videos/IntroMarieCurie.ogv"},
	{"escena": "res://minijuego-mary-agnes-chase/main.tscn", "ruta": "Joan", "animacion": "res://minijuego-mary-agnes-chase/videos/IntroMaryAgnes.ogv"},
	{"escena": "res://minijuego-joan-beauchamp/main.tscn", "ruta": "Vuelta", "animacion": "res://minijuego-joan-beauchamp/videos/IntroJoan.ogv"}
]
var index_minijuego = 0 # Indica en que minijuego estamos actualmente
var ruta_actual = "Florence" # La ruta que el mapa debe seguir actualmente
var animacion_inicial = "res://videos/IntroMatilda.ogv"
var animacion_final = "res://videos/Fin.ogv"
static var instancia # Instancia estática de la escena para poder llamarla fácilmente desde nodos inferiores en la jerarquía

########### MÉTRICAS ###########
var usuario = ""
var resultados = {}
var tiempo_inicio = 0
var url_formulario = "https://docs.google.com/forms/d/e/1FAIpQLSc_BQXzKbeGhdca3ZxU49EgiU_vMWbYOL856wVKPw2Mo1T-tA/formResponse?usp=pp_url"
var cabecera = ["Content-Type: application/x-www-form-urlencoded"]

########### FUNCIONES ###########
"""
Establece la escena principal como la instancia estática, establece un número
aleatorio de usuaro, la música de inicio y la máscara del botón de cerrar
"""
func _ready() -> void:
	instancia = self
	usuario = str(randi() % 1000).pad_zeros(4)
	Sonidos.stream = load("res://sonidos/dpstudiomusic-bounce-and-play-258924.mp3")
	Sonidos.play()
	var imagen = BotonCerrar.texture_normal.get_image()
	var mascara = BitMap.new()
	mascara.create_from_image_alpha(imagen)
	BotonCerrar.texture_click_mask = mascara
	
"""
Elimina los hijos de la escena actual, carga la animación de introducción al juego
y da paso al primer minijuego.
"""
func iniciar_juego() -> void:
	Sonidos.stop()
	Inicio.visible = false
	BotonPlay.disabled = true
	BotonPlay.visible = false
	for esc in Escena.get_children(): esc.queue_free()
	Animaciones.stream = load(animacion_inicial)
	Animaciones.play()
	await Animaciones.finished
	terminar_minijuego()
	
"""
Carga el siguiente minijuego de la lista y reproduce la animación de introducción a la científica correspondiente.
Posteriormente, establece la escena actual a la escena del minijuego.
Si ya se han completado todos los minijuegos, carga la escena final del juego.
"""
func siguiente_minijuego() -> void:
	for esc in Escena.get_children(): esc.queue_free()
	if index_minijuego < minijuegos.size():
		var info_minijuego = minijuegos[index_minijuego]
		Animaciones.stream = load(info_minijuego["animacion"])
		Animaciones.play()
		await Animaciones.finished
		Escena.add_child(load(info_minijuego["escena"]).instantiate())
		ruta_actual = info_minijuego["ruta"]
		index_minijuego += 1
	else:
		guardar_resultados()
		Animaciones.stream = load(animacion_final)
		Animaciones.play()
		Fin.visible = true
		await Animaciones.finished
		BotonSalir.visible = true
		BotonSalir.disabled = false
		BotonCerrar.visible = false
		BotonCerrar.disabled = true
		BotonCreditos.visible = true
		BotonCreditos.disabled = false
		Sonidos.stream = load("res://sonidos/openmindaudio-cartoon-kids-victory-sting-little-winner-glow-500914.mp3")
		Sonidos.play()

"""
Esta función se llama al ganar un minijuego y cambia la escena a la escena 
del collar para que vea la pieza conseguida.
"""
func terminar_minijuego() -> void:
	for esc in Escena.get_children(): esc.queue_free()
	Escena.add_child(load("res://collar.tscn").instantiate())
	
"""
Reinicia el minijuego de Sylvia, ya que es el único en el que se puede perder
y que pueda ser necesario intentarlo de nuevo
"""
func reintentar_minijuego():
	for esc in Escena.get_children(): esc.queue_free()
	Escena.add_child(load(minijuegos[1]["escena"]).instantiate())
		
"""
Esta función se llama después de ver la pieza obtenida y cambia la escena
a la escena del mapa para realizar ruta hacia la siguiente científica.
"""
func siguiente_ruta() -> void:
	for esc in Escena.get_children(): esc.queue_free()
	Escena.add_child(load("res://mapa.tscn").instantiate())

"""
Muestra la animación de las piezas del invento distribuyéndose por el mapa
"""
func distribuir_piezas() -> void:
	for esc in Escena.get_children(): esc.queue_free()
	Escena.add_child(load("res://animacion_piezas.tscn").instantiate())
	
"""
Guarda el tiempo en el que se ha iniciado un minijuego
"""
func iniciar_tiempo():
	tiempo_inicio = Time.get_ticks_msec()
	
"""
Acumula en el diccionario de resultados un valor asociado a una métrica
concreta para un minijuego concreto.
"""
func registrar_dato(minijuego: String, metrica: String, valor):
	if not resultados.has(minijuego):
		resultados[minijuego] = {}
	if not resultados[minijuego].has(metrica):
		resultados[minijuego][metrica] = 0
	if metrica == "tiempo":
		resultados[minijuego][metrica] += (valor - tiempo_inicio) / 1000.0
	else:
		resultados[minijuego][metrica] += valor

"""
Formatea los resultados para una métrica concreta
"""
func formatear_metrica(metrica: String) -> String:
	var texto = ""
	for minijuego in resultados.keys():
		if resultados[minijuego].has(metrica):
			texto += minijuego + ": " + str(resultados[minijuego][metrica])
			if metrica == "tiempo": texto += "s"
			texto += "\n"
	return texto
	
"""
Formatea los resultados que se han obtenido durante la ejecución del juego y los
envía a un formulario de google donde se irán almacenando.
"""
func guardar_resultados():
	var tiempos = formatear_metrica("tiempo")
	var fallos = formatear_metrica("fallos")
	var intentos = formatear_metrica("intentos")
	var datos = "entry.406128988=" + usuario.uri_encode()
	datos += "&entry.798513038=" + tiempos.uri_encode()
	datos += "&entry.2019650669=" + fallos.uri_encode()
	datos += "&entry.607113045=" + intentos.uri_encode()
	BaseDeDatos.request(url_formulario, cabecera, HTTPClient.METHOD_POST, datos)
	
"""
Muestra el diálogo para cerrar el juego
"""
func _on_boton_cerrar_pressed() -> void:
	DialogoCerrar.popup_centered()

"""
Cierra el juego
"""
func _on_dialogo_cerrar_confirmed() -> void:
	guardar_resultados()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

"""
Cierra el juego
"""
func _on_boton_salir_pressed() -> void:
	get_tree().quit()

"""
Muestra los créditos
"""
func _on_boton_creditos_pressed() -> void:
	Creditos.popup_centered()
