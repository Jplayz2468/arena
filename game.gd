extends Node2D
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var host_port: int = 135  # Port used when hosting
@export var remote_address: String = ""  # Set this in inspector when joining
@export var remote_port: int = 0  # Remote port (different from host port, set in inspector)

# Simple connection status
var connection_status = "Not connected"

func _on_host_pressed():
	# Create server on host_port
	var error = peer.create_server(host_port)
	if error != OK:
		print("Server creation failed with error: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	
	print("Server running on port ", host_port)
	_add_player()

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func _remove_player(id):
	if has_node(str(id)):
		get_node(str(id)).queue_free()

func _on_join_pressed():
	# Connect to the address and port set in the inspector
	if remote_address.is_empty():
		print("Remote address not set in inspector!")
		return
		
	if remote_port <= 0:
		print("Invalid remote port set in inspector!")
		return
	
	print("Connecting to ", remote_address, ":", remote_port)
	
	var error = peer.create_client(remote_address, remote_port)
	if error != OK:
		print("Client creation failed with error: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	
	# Add connection status signals with simple print statements
	multiplayer.connected_to_server.connect(func(): print("Connected successfully!"))
	multiplayer.connection_failed.connect(func(): print("Connection failed!"))
	multiplayer.server_disconnected.connect(func(): print("Server disconnected!"))
