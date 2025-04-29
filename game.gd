extends Node2D
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var host_port: int = 135
@export var remote_address: String = "34.59.164.46"  # Default to your VPS IP
@export var remote_port: int = 135  # Default to same port
@export var auto_host: bool = true  # Set to true for server, false for client

func _ready():
	# Simple connection status signals
	multiplayer.connected_to_server.connect(func(): print("Connected!"))
	multiplayer.connection_failed.connect(func(): print("Connection failed!"))
	
	# Automatically host if auto_host is true
	if auto_host:
		print("Auto-hosting enabled - starting server")
		start_server()

# Separate function for hosting
func start_server():
	var error = peer.create_server(host_port)
	if error != OK:
		print("Server creation failed with error:", error)
		return
		
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	
	print("Server running on port", host_port)
	_add_player()

func _on_host_pressed():
	start_server()

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func _remove_player(id):
	if has_node(str(id)):
		get_node(str(id)).queue_free()

func _on_join_pressed():
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null
		
	peer = ENetMultiplayerPeer.new()
	
	print("Connecting to", remote_address, ":", remote_port)
	
	var error = peer.create_client(remote_address, remote_port)
	if error != OK:
		print("Client creation failed with error:", error)
		return
		
	multiplayer.multiplayer_peer = peer
