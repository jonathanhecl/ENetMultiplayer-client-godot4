extends Node2D

var local_peer = 0
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _connected():
	$Status.text = "Connected"
	$Connect.hide()
	
func _disconnected():
	multiplayer.multiplayer_peer = null
	$Status.text = "Disconnected"
	$Connect.show()
	
	for c in range(len(get_children())):
		var ch = get_child(c)
		if ch.is_in_group("player"):
			ch.queue_free()

func _on_connect_pressed():
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
	var error = peer.create_client("localhost", 7070)
	if error != OK:
		$Status.text = "Error " + str(error)
		
	multiplayer.multiplayer_peer = peer

func _peer_connected(peer_id):
	if local_peer == 0:
		local_peer = peer.get_unique_id()
		peer_id = local_peer
		send_message_to_server.rpc("Hola Server, soy " + str(local_peer))
		
	($ItemList as ItemList).add_item("IN " + str(peer_id))
	
	print("_peer_connected: ", peer_id)
	add_peer(peer_id)

func _peer_disconnected(peer_id):
	if (local_peer == peer_id || # Me desconectan
		peer_id == 1):  		 # Se cierra el servidor
		local_peer = 0
	
	($ItemList as ItemList).add_item("OUT " + str(peer_id))
	
	print("_peer_disconnected: ", peer_id)
	remove_peer(peer_id)
	
func add_peer(peer_id):
	var player = player_scene.instantiate()
	
	player.name = str(peer_id)
	
	if local_peer == peer_id:
		player.is_local = true
		player.position.x = 574
		player.position.y = 307
	
	add_child(player)

func remove_peer(peer_id):
	
	for c in range(len(get_children())):
		var ch = get_child(c)
		if ch.is_in_group("player"):
			if ch.name.to_int() == peer_id:
				ch.queue_free()
				break

@rpc("any_peer")
func send_message_to_server(message: String):
	print("send_message_to_server: ", message)
	if multiplayer.is_server():
		send_message_to_client.rpc(message)
		
@rpc("authority")
func send_message_to_client(message: String):
	print("send_message_to_client: ", message)
