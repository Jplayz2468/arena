extends Node2D
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var host_port: int = 135  # Port used when hosting locally
@export var remote_address: String = ""  # Set in inspector for client (ngrok domain)
@export var remote_port: int = 0  # Set in inspector for client (ngrok port)

func _ready():
	# Set longer timeout for tunnel connections
	peer.transfer_channel = 0  # Use reliable channel
	peer.transfer_mode = ENetMultiplayerPeer.TRANSFER_MODE_RELIABLE

func _on_host_pressed():
	# Host always uses the local port
	var error = peer.create_server(host_port)
	if error != OK:
		print("Server creation failed with error: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	print("Server running on port ", host_port)

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_join_pressed():
	# Configure connection parameters
	peer.transfer_channel = 0
	peer.transfer_mode = ENetMultiplayerPeer.TRANSFER_MODE_RELIABLE
	
	print("Connecting to ", remote_address, ":", remote_port)
	var error = peer.create_client(remote_address, remote_port)
	if error != OK:
		print("Client creation failed with error: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	print("Connection attempt initiated")
