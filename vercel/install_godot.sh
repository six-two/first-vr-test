VERSION=4.4.1
set -e

# Download and unpack godot
curl -L https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_linux.x86_64.zip -o godot.zip;
unzip godot.zip
mv Godot_*.x86_64 godot
chmod +x godot

# # Download and unpack templates
# curl -L https://github.com/godotengine/godot/releases/download/$VERSION-stable/Godot_v$VERSION-stable_export_templates.tpz -o templates.tpz
# unzip templates.tpz
# mkdir -p ~/.local/share/godot/export_templates/$VERSION.stable/
# cp templates/web_* ~/.local/share/godot/export_templates/$VERSION.stable/

# Use templates from this repo. This is much faster, since it skips 1GB of files downloading and extracting
mkdir -p ~/.local/share/godot/export_templates/$VERSION.stable/
cp vercel/web_* ~/.local/share/godot/export_templates/$VERSION.stable/

# Create an empty folder for our project export
mkdir public
