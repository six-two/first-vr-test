# First VR Test

My first try to build a 3D / VR game with Godot.
It will probably suck and be abandoned.
But hey, it is a learning project for me.

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
