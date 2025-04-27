extends Node2D
 
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var server_port: int = 135
@export var server_address: String = ""  # Will be set via UI

# Add UI elements for server address input
@onready var address_input = $AddressInput  # Add this LineEdit to your scene

func _on_host_pressed():
	# Same as before, create a server on the specified port
	peer.create_server(server_port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
	# Display connection info to the host
	print("Server started on port: ", server_port)
	print("Give clients this address: Your tunnel URL + port ", server_port)

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func _on_join_pressed():
	# Parse the input which might be in format "address:port"
	var address_parts = address_input.text.split(":")
	
	server_address = address_parts[0]  # "8.tcp.us-cal-1.ngrok.io"
	
	# If port is specified in the address, use that instead of default
	if address_parts.size() > 1:
		server_port = int(address_parts[1])  # 16556
	
	print("Connecting to: ", server_address, ":", server_port)
	peer.create_client(server_address, server_port)
	multiplayer.multiplayer_peer = peer
