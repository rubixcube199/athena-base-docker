FROM athenaos/athena:base
RUN pacman -Syyu

#######################################################
###                  BASIC PACKAGES                 ###
#######################################################

RUN pacman -S --noconfirm --needed accountsservice alsa-utils btrfs-progs dhcpcd dialog inetutils man-db man-pages mesa mesa-utils most nano nbd net-tools netctl networkmanager nohang pavucontrol profile-sync-daemon pv rsync sof-firmware sudo timelineproject-hg wireless_tools wpa_supplicant xdg-user-dirs

#######################################################
###                   DEPENDENCIES                  ###
#######################################################

RUN pacman -S --noconfirm --needed electron libappindicator-gtk3 exa python-libtmux python-libtmux sassc hwloc ocl-icd pocl

#######################################################
###                 DISPLAY MANAGERS                ###
#######################################################

RUN pacman -S --noconfirm --needed gdm

#######################################################
###                      FONTS                      ###
#######################################################

RUN pacman -S --noconfirm --needed adobe-source-han-sans-cn-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts gnu-free-fonts nerd-fonts-jetbrains-mono ttf-jetbrains-mono

#######################################################
###                    UTILITIES                    ###
#######################################################

RUN pacman -S --noconfirm --needed ananicy asciinema bashtop bat bc bless btrfs-assistant btrfsmaintenance chatgpt-desktop-bin cmatrix code cowsay cron discord downgrade dunst eog espeakup figlet file-roller fortune-mod git gnome-characters gnome-control-center gnome-keyring gnome-menus gnome-shell-extensions gnome-themes-extra gnome-tweaks gparted grub-btrfs grub-customizer gtk-engine-murrine hexedit imagemagick jdk-openjdk jq kitty lolcat lsd nautilus neofetch networkmanager-openvpn nyancat octopi openbsd-netcat openvpn orca p7zip paru pfetch polkit polkit-gnome python-pywhat reflector sl snap-pac snap-pac-grub snapper textart tidy tk tmux toilet tree ufw unzip vim vnstat wayland wget which xclip xcp xdg-desktop-portal xdg-desktop-portal-gnome xmlstarlet zoxide

#######################################################
###                   CHAOTIC AUR                   ###
#######################################################

RUN pacman -S --noconfirm --needed chaotic-keyring chaotic-mirrorlist powershell

#######################################################
###                    BLACKARCH                    ###
#######################################################

RUN pacman -S --noconfirm --needed blackarch-keyring blackarch-mirrorlist

#######################################################
###                ATHENA REPOSITORY                ###
#######################################################

RUN pacman -S --noconfirm --needed athena-application-config athena-blue-eyes-theme athena-calamares athena-calamares-config athena-firefox-config athena-keyring athena-nvchad athena-pentoxic-menu athena-pwnage-menu athena-theme-tweak athena-vscode-themes athena-welcome figlet-fonts gnome-shell-extension-appindicator-git gnome-shell-extension-desktop-icons-ng gnome-shell-extension-fly-pie-git gnome-shell-extension-pop-shell-git gnome-shell-extension-ubuntu-dock-git htb-tools myman nist-feed superbfetch-git toilet-fonts

RUN pacman -S --noconfirm --needed --overwrite "/etc/pacman.d/gnupg/*" athena-system-config

#######################################################
###                    SERVICES                     ###
#######################################################

RUN pacman -S --noconfirm --needed openssh xorgxrdp xrdp
RUN pacman -S --noconfirm --needed openssl shellinabox

#######################################################
###                     noVNC                       ###
#######################################################

RUN pacman -S --noconfirm --needed libvncserver supervisor x11vnc xorg-server-xvfb
#RUN pacman -S --noconfirm --needed xfce4 xfce4-goodies xfce4-power-manager
RUN reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
RUN pacman -S --noconfirm --needed novnc
RUN echo "gnome-session --session=gnome" > ~/.xsession
RUN cp -r /etc/skel/. /root/. && echo 'root:athena' | chpasswd && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Expose needed ports
EXPOSE 22/tcp
EXPOSE 3389/tcp
EXPOSE 8080/tcp

# Set operable environment
ENV DISPLAY=:0

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN systemd-machine-id-setup
RUN useradd -ms /bin/bash athena
RUN usermod -aG wheel athena && echo "athena ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/athena
RUN chmod 044 /etc/sudoers.d/athena
##COPY docker-entrypoint.sh /
#USER athena:athena
#WORKDIR /home/athena
#RUN xdg-user-dirs-update

#ENTRYPOINT ["/docker-entrypoint.sh"]
# Launch X11, x11vnc, gnome and noVNC from supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf", "--pidfile", "/run/supervisord.pid"]
ENTRYPOINT []
