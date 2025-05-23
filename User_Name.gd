extends Node

func realistic_misspell(name: String) -> String:
	if name.length() == 0:
		return name
	
	var chars = name.to_lower()  # work in lowercase for simplicity
	var result = chars
	var typo_type = randi() % 4  # pick a typo pattern at random
	
	match typo_type:
		0:
			# Deletion: remove a random character
			if result.length() > 1:
				var del_idx = randi() % result.length()
				result = result.substr(0, del_idx) + result.substr(del_idx + 1, result.length() - del_idx - 1)
		
		1:
			# Insertion: insert a random nearby letter at a random position
			var insert_idx = randi() % (result.length() + 1)
			var letter = _random_nearby_letter(result[clamp(insert_idx - 1, 0, result.length() - 1)])
			result = result.substr(0, insert_idx) + letter + result.substr(insert_idx, result.length() - insert_idx)
		
		2:
			# Substitution: substitute a letter with a nearby letter on keyboard
			var sub_idx = randi() % result.length()
			var substitute = _random_nearby_letter(result[sub_idx])
			result = result.substr(0, sub_idx) + substitute + result.substr(sub_idx + 1, result.length() - sub_idx - 1)
		
		3:
			# Transposition: swap two adjacent letters
			if result.length() > 1:
				var swap_idx = randi() % (result.length() - 1)
				var chars_arr = result.split("")
				var temp = chars_arr[swap_idx]
				chars_arr[swap_idx] = chars_arr[swap_idx + 1]
				chars_arr[swap_idx + 1] = temp
				result = "".join(chars_arr)
	
	# Optionally restore capitalization of the first letter:
	result = result.capitalize()
	return result

func _random_nearby_letter(letter: String) -> String:
	# Map of letters to their common keyboard neighbors
	var neighbors = {
		"a": ["s", "q", "w", "z"],
		"b": ["v", "g", "h", "n"],
		"c": ["x", "d", "f", "v"],
		"d": ["s", "e", "r", "f", "c", "x"],
		"e": ["w", "s", "d", "r"],
		"f": ["d", "r", "t", "g", "v", "c"],
		"g": ["f", "t", "y", "h", "b", "v"],
		"h": ["g", "y", "u", "j", "n", "b"],
		"i": ["u", "j", "k", "o"],
		"j": ["h", "u", "i", "k", "m", "n"],
		"k": ["j", "i", "o", "l", "m"],
		"l": ["k", "o", "p"],
		"m": ["n", "j", "k"],
		"n": ["b", "h", "j", "m"],
		"o": ["i", "k", "l", "p"],
		"p": ["o", "l"],
		"q": ["w", "a"],
		"r": ["e", "d", "f", "t"],
		"s": ["a", "w", "e", "d", "x", "z"],
		"t": ["r", "f", "g", "y"],
		"u": ["y", "h", "j", "i"],
		"v": ["c", "f", "g", "b"],
		"w": ["q", "a", "s", "e"],
		"x": ["z", "s", "d", "c"],
		"y": ["t", "g", "h", "u"],
		"z": ["a", "s", "x"]
	}
	
	if letter in neighbors:
		var n_list = neighbors[letter]
		return n_list[randi() % n_list.size()]
	else:
		# If no neighbors, just return a random letter
		return String(char(97 + (randi() % 26)))
