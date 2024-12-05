{
  description = "Chris nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    whalebrew = {
      url = "github:whalebrew/whalebrew";
      flake = false;
    };
    # SFMono w/ patches
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nix-darwin
    , nixpkgs
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-bundle
    , whalebrew
    , sf-mono-liga-src
    }:

    let
      configuration = { pkgs, config, ... }: {

        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.allowBroken = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget

        environment.systemPackages = with pkgs;
          [
            # _1password-gui
            # terraform
            # ocaml
            # opam
            _1password-cli
            # aerospace
            alacritty
            ast-grep
            automake
            bat
            bat-extras.batdiff
            bat-extras.batgrep
            bat-extras.batman
            bat-extras.batpipe
            bat-extras.batwatch
            bat-extras.prettybat
            black
            broot
            btop
            cargo
            cmake
            curl
            deno
            direnv
            docker
            docutils
            espanso
            fd
            fzf
            fzy
            gh
            git
            gitui
            glow
            gnused
            go
            google-chrome
            httrack
            hub
            iterm2
            jankyborders
            karabiner-elements
            kitty
            lazygit
            libclang
            lua
            man
            mas
            mkalias
            mosh
            multitail
            neovim
            nodePackages.prettier
            nodejs_22
            obsidian
            oh-my-posh
            pandoc
            perl
            pipx
            pnpm
            prettierd
            pyenv
            python311
            python312
            python313
            qmk
            reattach-to-user-namespace
            ripgrep
            ruby
            rust-analyzer
            rustc
            rustfmt
            shfmt
            silver-searcher
            # sketchybar
            # sketchybar-app-font
            soundsource
            sphinx
            tmux
            transmission_4
            tree
            universal-ctags
            viu
            vlc-bin-universal
            wezterm
            wget
            yarn
            yazi
            yq
            zed-editor
            zig
            zip
            zoxide
            zsh
            yabai
            chroma
          ];

        homebrew = {
          enable = true;
          whalebrews = [ ];
          taps = [
          ];
          brews = [
          ];
          casks = [
            "calibre"
            "firefox"
            "1password"
            "adobe-acrobat-reader"
            "discord"
            "alfred"
            "backblaze"
            "chronosync"
            "daisydisk"
            "devonagent"
            "devonthink"
            "dropbox"
            "epic-games"
            "fork"
            "google-drive"
            "grammarly-desktop"
            "jabra-direct"
            "keyboard-maestro"
            "keycue"
            "logi-options+"
            "lulu"
            "miniconda"
            "moom"
            "notion"
            "omnifocus"
            "omnigraffle"
            "omnioutliner"
            "omniplan"
            "only-switch"
            "plus42-decimal"
            "qmk-toolbox"
            "setapp"
            "sf-symbols"
            "snagit"
            "spamsieve"
            "steam"
            "tageditor"
            "tradingview"
            "transmit"
            "trezor-suite"
            "wins"
          ];
          masApps = {
            "1Password for Safari" = 1569813296;
            "Actions" = 1586435171;
            "AdBlock Pro" = 1018301773;
            "AdGuard for Safari" = 1440147259;
            "Aiko" = 1672085276;
            "AudioBookBinder" = 413969927;
            "Audiobook Wizard" = 460967298;
            "Cardhop" = 1290358394;
            "Cheatsheet" = 1468213484;
            "Cityscapes" = 1631153096;
            "CleanMyDrive 2" = 523620159;
            "Coin Stats" = 1498417304;
            "Darkroom" = 953286746;
            "Data Jar" = 1453273600;
            "Deliveries" = 924726344;
            "Developer" = 640199958;
            "Disk Speed Test" = 425264550;
            "Encrypto" = 935235287;
            "Fantastical" = 975937182;
            "Focus" = 777233759;
            "Goodnotes" = 1444383602;
            "Grammarly for Safari" = 1462114288;
            "Ground News" = 1324203419;
            "HP Smart" = 1474276998;
            "Keynote" = 409183694;
            "Kiwix" = 997079563;
            "Live Wallpaper" = 531123879;
            "Menu Box" = 6463440793;
            "NordVPN" = 905953485;
            "Notability" = 360593530;
            "Numbers" = 409203825;
            "OneDrive" = 823766827;
            "PCalc" = 403504866;
            "Pages" = 409201541;
            "PayPal Honey" = 1472777122;
            "Photomator" = 1444636541;
            "Reeder" = 6475002485;
            "Save to Medium" = 1485294824;
            "Shazam" = 897118787;
            "Shortery" = 1594183810;
            "ShutterCount" = 720123827;
            "SimpleumSafe" = 1547771496;
            "Slack" = 803453959;
            "Speedtest" = 1153157709;
            "Texifier" = 458866234;
            "The Unarchiver" = 425424353;
            "Tot" = 1491071483;
            "Userscripts-Map-App" = 1463298887;
            "WhatsApp" = 310633997;
            "Xcode" = 497799835;
            "iA Writer" = 775737590;
            "iMovie" = 408981434;
          };
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages = with pkgs; ([
          sf-mono-liga-bin
          nerd-fonts.monaspace
          nerd-fonts.bigblue-terminal
          nerd-fonts.caskaydia-cove
          nerd-fonts.caskaydia-mono
          nerd-fonts.comic-shanns-mono
          nerd-fonts.dejavu-sans-mono
          nerd-fonts.envy-code-r
          nerd-fonts.fira-code
          nerd-fonts.fira-mono
          nerd-fonts.hack
          nerd-fonts.im-writing
          nerd-fonts.inconsolata
          nerd-fonts.inconsolata-go
          nerd-fonts.iosevka
          nerd-fonts.iosevka-term
          nerd-fonts.iosevka-term-slab
          nerd-fonts.jetbrains-mono
          nerd-fonts.lilex
          nerd-fonts.meslo-lg
          nerd-fonts.open-dyslexic
          nerd-fonts.sauce-code-pro
          nerd-fonts.symbols-only
          nerd-fonts.victor-mono
          nerd-fonts.zed-mono
        ]
        );

        nixpkgs.overlays =
          [
            (final: prev: {
              sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
                pname = "sf-mono-liga-bin";
                version = "dev";
                src = inputs.sf-mono-liga-src;
                dontConfigure = true;
                installPhase = ''
                  mkdir -p $out/share/fonts/opentype
                  cp -R $src/*.otf $out/share/fonts/opentype/
                '';
              };
            })
          ];

        # programs.zsh.oh-my-zsh.customPkgs = [
        #   nix-zsh-completions
        #   zsh-autosuggestions
        #   zsh-completions
        #   zsh-fast-syntax-highlighting
        #   zsh-syntax-highlighting
        #   zsh-vi-mode
        #   zsh-lazyload
        # ];

        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in
          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';


        # system.defaults = {
        #   dock.autohide = true;
        #   dock.persistent-apps = [
        #     "/Applications/Setapp/Path Finder.app"
        #     "/Applications/Safari.app"
        #     "/Applications/Nix Apps/Google Chrome.app"
        #     "/System/Applications/Mail.app"
        #     "/Applications/Setapp/Spark Mail.app"
        #     "/System/Applications/Messages.app"
        #     "/Applications/WhatsApp.app"
        #     "/System/Applications/System Settings.app"
        #     "/Applications/1Password.app"
        #     "/Applications/Fantastical.app"
        #     "/Applications/OmniFocus.app"
        #     "/Applications/Cardhop.app"
        #     "/System/Applications/Music.app"
        #     "/Applications/Notability.app"
        #     "/Applications/Nix Apps/kitty.app"
        #     "/Applications/kitty.app"
        #     "/Applications/Citrix Workspace.app"
        #     "/Applications/Nix Apps/Obsidian.app"
        #     "/Applications/Parallels Desktop.app"
        #     "/System/Applications/iPhone Mirroring.app"
        #   ];
        #   loginwindow.GuestEnabled = false;
        #   NSGlobalDomain.AppleInterfaceStyle = "Dark";
        # };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        programs.zsh.enable = true; # default shell
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "x86_64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#nAragorn
      darwinConfigurations."nAragorn" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = "chris";
              autoMigrate = true;
            };
          }
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."nAragorn".pkgs;
    };
}
