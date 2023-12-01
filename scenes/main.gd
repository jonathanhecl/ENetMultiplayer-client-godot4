extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _process(delta):
	var status = peer.get_connection_status()
	if status == peer.CONNECTION_CONNECTED:
		$Status.text = "Connected"
	elif status == peer.CONNECTION_CONNECTING:
		$Status.text = "Connecting"
	else:
		$Status.text = "Disconnected"

func _on_connect_pressed():
	var error = peer.create_client("localhost", 7070)
	if error != OK:
		$Status.text = "Error " + error
	else:
		$Status.text = "Connected"
		multiplayer.multiplayer_peer = peer
