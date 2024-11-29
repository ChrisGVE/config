{
  description = "Chris nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs;
          [
            # _1password-gui
            # conda
            # discord
            # terraform
            _1password
            ast-grep
            automake
            bat
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
            gcc-arm-embedded
            gh
            git
            gitui
            glow
            gnused
            go
            httrack
            hub
            kitty
            lazygit
            lua
            man
            mkalias
            mosh
            multitail
            neovim
            nodejs_22
            obsidian
            ocaml
            oh-my-zsh
            opam
            pandoc
            perl
            pipx
            pnpm
            pyenv
            python311
            python312
            python313
            reattach-to-user-namespace
            ripgrep
            ruby
            rust-analyzer
            rustc
            silver-searcher
            sketchybar
            sphinx
            tmux
            tree
            universal-ctags
            viu
            wget
            yarn
            yazi
            zed
            zig
            zip
            zoxide
            zsh
            zsh-syntax-highlighting
          ];

        homebrew = {
          enable = true;
          taps = [
            "nikitabobko/tap"
            "FelixKratz/formulae"
            "qmk/qmk"
          ];
          brews = [
            "mas"
            "borders"
            "sketchybar"
            "whalebrew"
            "qmk"
            "osx-cross/avr"
          ];
          casks = [
            "font-sketchybar-app-font" # Required for sketchybar
            "aerospace"
            "qmk-toolbox"
            "only-switch"
            "sf-symbols"
            "miniconda"
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
        ]) ++ (

          with pkgs.nerd-fonts; [
            bigblue-terminal
            caskaydia-cove
            caskaydia-mono
            comic-shanns-mono
            dejavu-sans-mono
            envy-code-r
            fira-code
            fira-mono
            hack
            im-writing
            inconsolata
            inconsolata-go
            iosevka
            iosevka-term
            iosevka-term-slab
            jetbrains-mono
            lilex
            meslo-lg
            open-dyslexic
            sauce-code-pro
            symbols-only
            victor-mono
            zed-mono
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

        system.defaults = {
          dock.autohide = true;
          dock.persistent-apps = [
            # "/System/Applications/Finder.app"
          ];
          loginwindow.GuestEnabled = false;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
        };

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
              # taps = {
              #   "homebrew/homebrew-core" = homebrew-core;
              #   "homebrew/homebrew-cask" = homebrew-cask;
              #   "homebrew/homebrew-bundle" = homebrew-bundle;
              # };
              # mutableTaps = false;
            };
          }
        ];
      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."nAragorn".pkgs;
    };
}
