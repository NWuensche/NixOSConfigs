# Edit this configuration file to define what should be installed :wqon
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

       networking.wireless.userControlled.enable = true;
    

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";



  networking.nameservers = [

    "8.8.8.8"
    "fe80::1%wlp4s0"
  ];
 
  programs.vim.defaultEditor = true;

  security.sudo.extraConfig = "nwuensche ALL=(root) NOPASSWD: /run/wrappers/bin/light-intel"; # Make background light working

  users.users.nwuensche.shell = pkgs.zsh;

  fonts.fonts = with pkgs; [
    powerline-fonts
  ];
  fonts.enableDefaultFonts = true;


  security.wrappers.light-intel = { source = pkgs.writeScript "light-intel" 
''
#!/bin/sh
CURR=$(cat /sys/class/backlight/intel_backlight/brightness)
echo $(($CURR+$1)) | sudo tee /sys/class/backlight/intel_backlight/brightness
''; 
owner = "root"; setuid = true; };

# Need this just for bLight service
  security.wrappers.light-intel-abs = { source = pkgs.writeScript "light-intel-abs" 
''
#!/bin/sh
echo $1 | tee /sys/class/backlight/intel_backlight/brightness
''; 
owner = "root"; setuid = true; };

  security.wrappers.i3lock-custom = { source = pkgs.writeScript "i3lock-custom" 
''
#!/bin/sh
i3lock
''; 
owner = "nwuensche"; setuid = false; };

  security.wrappers.i = { source = pkgs.writeScript "i" 
''
#!/bin/sh
/run/current-system/sw/bin/idea-community

''; 
owner = "nwuensche"; setuid = false; };

  security.wrappers.a = { source = pkgs.writeScript "a" 
''
#!/bin/sh
/run/current-system/sw/bin/android-studio

''; 
owner = "nwuensche"; setuid = false; };

  security.wrappers.t = { source = pkgs.writeScript "t" 
''
#!/bin/sh
/run/current-system/sw/bin/thunderbird
''; 
owner = "nwuensche"; setuid = false; };

  security.wrappers.lowriter = { source = pkgs.writeScript "lowriter" 
''
#!/bin/sh
/run/current-system/sw/bin/libreoffice --writer
''; 
owner = "nwuensche"; setuid = false; };

  security.wrappers.lowbattery = { source = pkgs.writeScript "lowbattery" 
''
#!/bin/sh
while true; do
  Curr=$(/run/current-system/sw/bin/cat /sys/class/power_supply/BAT0/energy_now);
  Min="2400000";
  if ((Curr < Min))
  then
       /run/current-system/sw/bin/zenity --info --text="Battery to 5%"
  fi
  sleep 300 #wait 5 minutes
  kill $!
done
''; 
owner = "nwuensche"; setuid = false; };

  hardware.trackpoint.emulateWheel = true;

  boot.loader.timeout = 0;
  networking.extraHosts = "
127.0.0.1 www.9gag.com
 127.0.0.1 9gag.com
127.0.0.1 https://9gag.com
127.0.0.1 www.youtube.com
127.0.0.1 www.instagram.com
127.0.0.1 www.facebook.com
127.0.0.1 https://twitter.com
127.0.0.1 https://twitter.com/
127.0.0.1 www.twitter.com
127.0.0.1 twitter.com
127.0.0.1   apps.facebook.com
127.0.0.1 m.twitter.com
  ";

# Mount everything in /media
   
#systemd.services.rfkill-own = {
  #description = "RFKill-Block WLAN";
  #serviceConfig = {
    #Type = "oneshot";
    #after = [ "multi-user.target" ];
    #ExecStart = "/run/current-system/sw/bin/rfkill block wlan";
    #};
    #wantedBy = [ "multi-user.target" ];
    #enable = true;
    #};

  systemd.services.bLight = {
   description = "Set background light";
   serviceConfig = {
     Type = "oneshot";
     after = [ "multi-user.target" ];
     ExecStart = "/run/wrappers/bin/light-intel-abs 250";
     #ExecStart = "/run/current-system/sw/bin/echo 400 > /sys/class/backlight/intel_backlight/brightness";
   };
   wantedBy = [ "multi-user.target" ];
   enable = true;
 };

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

   networking.hostName = "nixos"; # Define your hostname.
   networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Select internationalisation properties.
   i18n = {
  #   consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "euro";
      defaultLocale = "de_DE.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
   environment.systemPackages = with pkgs; [
     xz
     wget
     vim
     sudo
     i3
     chromium 
     terminator
     jre
     openjdk
     git
     jetbrains.idea-community
     android-studio
     hexchat
     htop
     ghc
     gparted
     gradle
     imagemagick
     geeqie
     curl
     ffmpeg
     evince
     gimp
     oh-my-zsh
     pamixer
     pavucontrol
     pmutils
     pulseaudioFull
     pwgen
     texlive.combined.scheme-full
     vimPlugins.latex-live-preview
     xf86_input_mtrack
     xorg.xf86inputsynaptics
     xorg.xf86videointel
     cron
     calibre
     audacity
     arandr
     cups
     aspell
     aspellDicts.de
     maven
     #rubber #Latex
     tetex
     mariadb
     libreoffice
     steam
     acpi
     alsa-firmware
     binutils
     dmenu
     dpkg
     gcc
     gnumake
     help2man
     jmtpfs
     lsof
     mesa
     ntfs3g
     gnome2.zenity #GUI notifcations
     calc
     #teamviewer
     #nitrogen
     feh
     #(pkgs.nitrogen.overrideAttrs (oldAttrs: {
       #   wallpaper = pkgs.fetchurl {
         #   url = "https://i.pinimg.com/originals/02/fd/92/02fd92edf03b167382be63790ada0d20.jpg";
         # sha256 = "1xbmqmm0clnfialj5f8w1g85ivdszr1ih40qxpfrj1nn0rkl9pv3";
         #        };
         #      postInstall = ''
         #      cp $wallpaper $out/wallpaper.jpg
         #         '';
           #       buildInputs = oldAttrs.buildInputs + [ wget ];
           #  }))
     xss-lock
     xautolock
     gist
     tcsh
     pmutils
     ntfs3g #allow write for NTFS devices
     physlock
     i3lock
     xorg.xev
     jmtpfs # mtp with Android
     vimPlugins.vundle
     pwgen
     xclip
     dmenu
          thunderbird
     #(pkgs.thunderbird.overrideAttrs (oldAttrs: {
       #  postInstall = oldAttrs.postInstall + ''
       #echo 'pref("useragent.locale", "de");' > $out/lib/thunderbird-52.2.1/defaults/pref/local-settings.js 
       #'';
       #    }))
    #     (pkgs.teamviewer.overrideAttrs (oldAttrs: {
      #   version = "12.0.76279";
      #}))
     hunspell_1_6
     redshift
     pandoc
     phantomjs
     python36
     zsh
     unzip
     vifm
     virtualbox
     vlc
     #wine 
     #winetricks
     python35Packages.youtube-dl-light
     trash-cli
     truecrypt
     udiskie
     tdesktop #Telegram
     sshfs-fuse 
     super-user-spark 
     iw
     wpa_supplicant
     wpa_supplicant_gui
     i3status
     pamixer
     scrot
    #(pkgs.oh-my-zsh.overrideAttrs (oldAttrs: rec {
    #phases = "installPhase customThemePhase";
    #srcTheme = fetchurl {
        #url = "https://raw.githubusercontent.com/NWuensche/dotFiles/master/terminalStuff/agnoster.zsh-theme";
        #sha256 = "b99455c561bdcf9ec0601669da3d1aa680328ec1836430de22c6e7e32497ea5b";
    #};
    #customThemePhase = "
    #chmod +w $outdir/themes/agnoster.zsh-theme
    #cp $srcTheme $out/share/oh-my-zsh/themes/agnoster.zsh-theme
#";
  #}))
   ];

    programs.zsh = {
  enable = true;
        ohMyZsh = let 
      packages = [
        {
            owner = "nwuensche";
            repo = "dotFiles";
            rev = "6efde8b3fa744d1c9d6cd5bab9968000dbbf6303"; #Commit
            sha256 = "0n8xagqilkw13h20knb6by6ycpqjrx0qdjnpiaizbfkj8j5p4nyj";
        }
      ];

      fetchToFolder = { repo, ...}@attrs:
        pkgs.fetchFromGitHub (attrs // {
          extraPostFetch = ''
            tmp=$(mktemp -d)
            mv $out/* $tmp
            mkdir $out/${repo}
            mv $tmp/* $out/${repo}
          '';
        });
      custom = pkgs.buildEnv {
        name = "zsh-custom";
        paths = builtins.map fetchToFolder packages;
      };
    in
    {
      enable = true;
      custom = custom.outPath;
      theme = "dotFiles/terminalStuff/agnoster";
      plugins = [ "git" "pass" "brew" "colored-man" "colorize" ];
    };
};
  nixpkgs.config.allowUnfree = true; #For Steam
  hardware.opengl.driSupport32Bit = true; #For Steam
  hardware.pulseaudio.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.mutableUsers = false;

  users.extraUsers.nwuensche = {
    isNormalUser = true;
    home = "/home/nwuensche";
    description = "Niklas";
    extraGroups = ["wheel" "networkmanager" "cups"];
    hashedPassword = "$6$Xq1B38LOXaM4y$kBFC49X..bv46F8mINe4O4tr5wJp2i92G0jAkkdBsGI1Wkn0CLnsSxw1bgBOJ2oDX6s6JDlrMOVLq5./RrU2m/";
  };
  security.sudo.wheelNeedsPassword = true;

# Screen Locking (time-based & on suspend) + Keyboard

   services = {
    acpid = {
      enable = true;
      lidEventCommands = ''
        #if grep -q closed /proc/acpi/button/lid/LID/state; then
        #  date >> /tmp/i3lock.log
        #  DISPLAY=":0.0" XAUTHORITY=/home/fadenb/.Xauthority ${pkgs.i3lock}/bin/i3lock &>> /tmp/i3lock.log
        #fi
              '';
    };
    xserver = {
        videoDrivers = [  "intel"  ];
       deviceSection = ''
           Option      "Backlight"  "intel_backlight"
       '';
      enable = true;
      windowManager.i3.enable = true;
      #      windowManager.i3.configFile = let original = builtins.readFile /home/nwuensche/.i3/config; wallpaper = pkgs.fetchurl { 
        #url = "https://i.pinimg.com/originals/02/fd/92/02fd92edf03b167382be63790ada0d20.jpg";
             #       sha256 = "1xbmqmm0clnfialj5f8w1g85ivdszr1ih40qxpfrj1nn0rkl9pv3";
             #      }; fehSnippet = "\nexec_always --no-background-id  ${pkgs.feh}/bin/feh --bg-scale ${wallpaper}"; in pkgs.writeText "config" (original + fehSnippet);
      #     windowManager.i3.configFile = builtins.readFile /home/nwuensche/.i3/config + ''exec ${pkgs.feh}/bin/feh --bg-scale ${pkgs.fetchurl {
        #       url = "https://i.pinimg.com/originals/02/fd/92/02fd92edf03b167382be63790ada0d20.jpg";
        #     sha256 = "1xbmqmm0clnfialj5f8w1g85ivdszr1ih40qxpfrj1nn0rkl9pv3";
        # }} '';
        #      windowManager.i3.extraSessionCommands = ''${pkgs.feh}/bin/feh --bg-scale ${pkgs.fetchurl {
          #     url = "https://i.pinimg.com/originals/02/fd/92/02fd92edf03b167382be63790ada0d20.jpg";
          #   sha256 = "1xbmqmm0clnfialj5f8w1g85ivdszr1ih40qxpfrj1nn0rkl9pv3";
          #         }} '';
      synaptics.enable = true;
      multitouch.enable = true;
      synaptics.maxSpeed = "0.3";
      synaptics.minSpeed = "0.1"; 
       displayManager.sessionCommands = ''
                     setxkbmap eu -option caps:escape
         xautolock -locker i3lock -time 10& #suspend lock
         xss-lock -- i3lock & #lid close lock
        #  ${pkgs.xautolock}/bin/xautolock -detectsleep -time 1 \
        #                -locker "${pkgs.i3lock}/bin/i3lock -c 000070" &
        #  ${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.i3lock}/bin/i3lock -c 000070 &
       '';
    };
    sshd.enable = true;
    #udev.extraRules = ''
	#ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{UDISKS_FILESYSTEM_SHARED}="1"	
    #  '';
  printing.enable = true;
  printing.drivers = [ pkgs.splix (( pkgs.callPackage_i686 /home/nwuensche/brotherppd/printer2.nix) { }) (( pkgs.callPackage_i686 /home/nwuensche/brotherppd2/printer2.nix) { })];
   };
  services.printing.extraConf = ''LogLevel debug'';
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";


}
