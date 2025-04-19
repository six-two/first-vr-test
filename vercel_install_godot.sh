VERSION=

# Download and unpack godot
curl -L https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_linux.x86_64.zip -o godot.zip;
unzip godot.zip
mv Godot_*.x86_64 godot
chmod +x godot

# Download and unpack templates
curl -L https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_export_templates.tpz -o templates.tpz
unzip templates.tpz
mkdir -p ~/.local/share/godot/export_templates/$VERSION.stable/
cp templates/web_* ~/.local/share/godot/export_templates/$VERSION.stable/
