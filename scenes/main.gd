extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _process(delta):
	var status = peer.get_connection_status()
	if status == peer.CONNECTION_CONNECTED:
		$Status.text = "Connected"
		$Connect.hide()
	elif status == peer.CONNECTION_CONNECTING:
		$Status.text = "Connecting"
		$Connect.hide()
	else:
		$Status.text = "Disconnected"
		$Connect.show()

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
	print("_peer_connected: ", peer.get_unique_id())
	add_peer(peer.get_unique_id())		

func _peer_disconnected(peer_id):
	remove_peer(peer_id)

func _connected():
	$Status.text = "Connected"
	
func _disconnected():
	multiplayer.multiplayer_peer = null
	$Status.text = "Disconnected"
	
func add_peer(peer_id = 1):
	var player = player_scene.instantiate()
	
	player.name = str(peer_id)
	player.position.x = 574
	player.position.y = 307
	
	call_deferred("add_child", player)

func remove_peer(peer_id = 1):
	for c in range(len(get_children())):
		var ch = get_child(c)
		if ch.is_in_group("player"):
			if ch.name.to_int() == peer_id:
				ch.queue_free()
				break
