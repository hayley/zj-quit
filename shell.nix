{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Rust dependencies
    gcc
    pkg-config
    zlib
    openssl
    glib
    pango
    libsoup_3
    atk
    webkitgtk_4_1
    cairo
    gdk-pixbuf
    xdotool # needed for dioxus desktop

    # Playwright and Node.js
    nodejs_20
    playwright-driver
    chromium # Add explicit chromium package

    # Additional dependencies for headless browser testing
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    mesa
    alsa-lib
    cups
    dbus
    libdrm
    libxkbcommon
    nspr
    nss

    # Font dependencies
    freetype
    fontconfig

    # Build tools
    gnumake
  ];

  # Set up environment variables for Playwright under NixOS
  shellHook = ''
    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    # Skip Playwright's host requirements validation as NixOS handles dependencies differently
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true

    # Use system Chromium instead of trying to find it in the Playwright browsers path
    # export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=${pkgs.chromium}/bin/chromium

    # Ensure node_modules/.bin is in PATH
    export PATH="$PWD/node_modules/.bin:$PATH"

    echo "Playwright environment successfully configured for NixOS"
    echo "Using Chromium at: $PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH"
  '';
}
