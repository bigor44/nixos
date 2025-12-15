{ pkgs, ... }:
let
  inherit (pkgs) lib;
  pname = "turtle-wow";
  version = "27082025";

  src = pkgs.fetchurl {
    url = "https://turtle-eu.b-cdn.net/client/9BEF2C29BE14CF2C26030B086DFC854DB56096DDEAABE31D33BFC6B131EC5529/TurtleWoW.AppImage";
    hash = "sha256-/4qRkc6m+F0djc0YoIfMZxwHaZsrowkyc9O6jS5fUEk=";
  };

  # ============================================================================
  # Wayland Compatibility
  # ============================================================================
  # The game client requires specific Wayland libraries to be preloaded
  # to function correctly in a pure Wayland environment.
  # ============================================================================
  waylandClient = "${lib.getLib pkgs.wayland}/lib/libwayland-client.so.0";
  waylandCursor = "${lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0";
  preload = lib.concatStringsSep ":" [
    waylandClient
    waylandCursor
  ];
in
# ============================================================================
# Turtle WoW Client Wrapper
# ============================================================================
# Wraps the official AppImage to inject Wayland compatibility libraries
# (via LD_PRELOAD) and installs a desktop entry.
# ============================================================================
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  name = pname;

  extraInstallCommands = ''
    mv "$out/bin/${pname}" "$out/bin/${pname}-unwrapped"

    # This script sets LD_PRELOAD to inject the necessary Wayland libraries
    # before launching the actual game executable.
    cat > "$out/bin/${pname}" <<'EOF'
    #!${pkgs.runtimeShell}
    export LD_PRELOAD='${preload}'
    exec "$(dirname "$0")/${pname}-unwrapped" "$@"
    EOF
    chmod +x "$out/bin/${pname}"

    mkdir -p $out/share/applications
    cat > $out/share/applications/${pname}.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=Turtle WoW
    Comment=Turtle WoW Client
    Exec=${pname}
    Icon=applications-games
    Categories=Game;
    Terminal=false
    EOF
  '';
}
