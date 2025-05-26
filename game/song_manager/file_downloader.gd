extends Node

func get_filename_from_url(url: String) -> String:
	var url_path = url.split("?")[0]
	return url_path.get_file()


func on_button_download_pressed():
	var url = $MarginContainer/VBoxContainer/TextEdit.text
	var file_path = "user://custom-songs/" + get_filename_from_url(url)
	download_from_url(url, file_path, null)

func download_from_url(url: String, output_path: String, callback_success) -> void:
	var dir_path = output_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		print("[*] Directory '%s' doesn't exist. Creating it..." % dir_path)
		if DirAccess.make_dir_recursive_absolute(dir_path) != OK:
			print("[-] Failed to create directory, aborting download")
			return
	
	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.connect("request_completed", 
		func(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
			if result == HTTPRequest.RESULT_SUCCESS:
				var file = FileAccess.open(output_path, FileAccess.WRITE)
				
				if file != null:
					file.store_buffer(body)
					print("[+] File %s downloaded successfully" % output_path.replace("user:/", OS.get_user_data_dir()))
					callback_success.call()
				else:
					print("[-] Error opening file for writing: %s" % output_path)
			else:
				print("[-] Unknown download status: ", result)
			
			http_request.queue_free()
	)
	
	print("[*] Downloading ", url)
	var error = http_request.request(url, [], HTTPClient.METHOD_GET)
	if error != OK:
		print("[-] Error starting request for %s: %s" % [url, error])
