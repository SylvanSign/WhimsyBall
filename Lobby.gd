extends Node

const SERVER_PORT := 1000
const SERVER_IP := 'localhost'
const MAX_PLAYERS := 2

# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

func init_server() -> void:
	var peer := NetworkedMultiplayerENet.new()
	var error := peer.create_server(SERVER_PORT, MAX_PLAYERS)
	assert(error == OK)
	get_tree().network_peer = peer

func init_client() -> void:
	var peer := NetworkedMultiplayerENet.new()
	var error := peer.create_client(SERVER_IP, SERVER_PORT)
	assert(error == OK)
	get_tree().network_peer = peer

func leave_network() -> void:
	get_tree().network_peer = null

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

remote func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	player_info[id] = info

	# Call function to update lobby UI here
