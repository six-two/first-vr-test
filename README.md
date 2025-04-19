# First VR Test

My first try to build a 3D / VR game with Godot.
It will probably suck and be abandoned.
But hey, it is a learning project for me.

If you want to try it out (you will need a VR headset like an Oculus Quest):

1. Download [Godot](https://godotengine.org/download/) (the non-C# / non-mono / non-.NET version).
2. Clone this repository and import it in godot.
3. Set your local IP address in the Godot settings.
    In macOS open the menu `Godot` -> `Editor Settings...`, then enable the `Advanced Settings` toggle, visit the `Export` -> `Web` section, and finally set `HTTP Host` to your local IP address.
4. Start the Godot builtin web server (Looks like a TV button in yhe top toolbar) -> `Start HTTP server`
5. Put on your headset and in the headset open `https://YOUR_LOCAL_IP:8060/tmp_js_export.html` via the builtin web browser.
    Wait for the site to load and click `Start VR`.
