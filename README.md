# First VR Test

My first try to build a 3D / VR game with Godot.
It will probably suck and be abandoned.
But hey, it is a learning project for me.

Currently it is a pretty bare bones Taiko like game, that can play some TJA files (but does not support features like drumb rolls, branching, etc).

## Demo

If you want to try it out, put on your headset, open <https://first-vr-test.vercel.app> in the headset's web browser and click `Start VR`.
I only have tested it with Quest headsets, so it may not work for other headsets.
A very basic description of the goal and key bindings is described [here](taiko_vr/tutorial.md).

## Build from source

If you want to play around with the project, you have to follow these steps:

1. Download [Godot](https://godotengine.org/download/) (the non-C# / non-mono / non-.NET version).
2. Clone this repository and import it in godot.
3. Set your local IP address in the Godot settings.
    In macOS open the menu `Godot` -> `Editor Settings...`, then enable the `Advanced Settings` toggle, visit the `Export` -> `Web` section, and finally set `HTTP Host` to your local IP address.
4. Start the Godot builtin web server: click button that looks like a TV button in the top toolbar -> `Start HTTP server`
5. Put on your headset and in the headset open `https://YOUR_LOCAL_IP:8060/tmp_js_export.html` via the builtin web browser.
    Wait for the site to load and click `Start VR`.

Afterwards if you change something in the code, you can just click the button that looks like a TV button in the top toolbar -> `Re-export Project`.
Then reload the tab in your headset's web browser and you should be running the new build.

## Adding Songs

Paste songs (mp3/ogg + TJA) into:

- macOS: `~/Library/Application Support/Godot/app_userdata/First VR test/song-index/`

### Song index

Alternatively you can import an index to be able to download songs from online repositories.
An index is basically just a JSON file that says which songs can be downloaded from where.
The idea is that you can easily download songs from large repositories (1000s of songs / 10s of GBs), that would cause performance or storage issues on devices like an Oculus Quest 2.

#### Creating a song index

You can create an index from a repository using the `generate-song-index-json.py` script:

1. Clone/download the repository you want to create an index for:
    ```bash
    git clone https://git.example.com/username/repository
    ```
2. Generate an index JSON:
    ```bash
    python3 ./generate-song-index-json.py -u https://git.example.com/username/repository/raw/branch/master/ -d ./repository/ > repository.json
    ```

Alternatively, someone else may have already created an index for a repository you want.

#### Using a song index

You can then transfer the index to your target device and download individual songs from there:

1. Copy the index JSON to your `song-index` folder.
    On macOS:
    ```bash
    cp repository.json ~/Library/Application Support/Godot/app_userdata/First VR test/song-index/
    ```

    If the index file is hosted on a web server, you can also download it by going to the song menu screen, clicking the `Add index` button, pasting the URL of the file in the text box and clicking `Download`.
2. Start the game.
    On the song list screen there should be a `Download` button in the lower left corner.
    If you click it, you get to a menu where you can select and download any songs from the index.
