extends Node
# This needs to be fixed and will be once I fix a certain bug with
# queue. I also need to talk to Luke about what features need to be linked.

const SERVER_PORT = 8080 # Example port
const SERVER_IP = "127.0.0.1" # Example ip

# var multiplayer_scene = preload("res://scenes/multiplayer_player.tscn")

var _players_spawn_node


func host():
	print("Hosting Started")
	
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")

	var server_peer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)

	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player_to_game)
#	multiplayer.peer_disconnected.connect(_del_player)
	
#	_remove_single_player()
	_add_player_to_game(1)
	
func join():
	print("Joined")
	
	var client_peer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer

#	_remove_single_player()

func _add_player_to_game(id: int):
	print("Player %s joined game" % id)
	
#	var player_to_add = multiplayer_scene.instantiate()
#	player_to_add.player_id = id
#	player_to_add.name = str(id)
	
#	_players_spawn_node.add_child(player_to_add, true)
	
#func _del_player(id: int):
#	print("Player %s left game" % id)
