extends HBoxContainer

########### VARIABLES GLOBALES ###########
@export var vida_perdida: Texture2D

"""
Esta función se llama cuando la buceadora pierde una vida. Obtiene
la vida actual y le cambia la textura a la textura de vida perdida
"""
func _on_buceadora_perder_vida(vidas_restantes) -> void:
	var vida := get_child(vidas_restantes) as TextureRect 
	vida.texture = vida_perdida 
