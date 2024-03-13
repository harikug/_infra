#!/bin/bash
declare -A installers
installers[all]="install_all"
installers[ansible]="install_ansible"
installers[cli]="install_cli"
installers[dirs]="install_dirs"
installers[librefox]="install_librefox"
installers[nvm]="install_nvm"
installers[sdkman]="install_sdkman"
installers[swappiness]="install_swappiness"
installers[updates]="install_updates"
installers[snaps]="install_snaps"
installers[snaps_classic]="install_snaps_classic"

install_updates() {
  sudo apt-get update
  sudo snap refresh
}

install_docker() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
}

install_sdkman() {
  curl -s "https://get.sdkman.io" | bash
}

install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
}

install_cli() {
  sudo apt-get install \
  apt-transport-https \
  software-properties-common \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  gnome-tweaks \
  gnome-shell-extension-manager \
  wget \
  rsync \
  fuse \
  libfuse2 \
  ranger \
  fdupes
}


install_dirs() {
    for key in "$HOME/.dockervols.d" "$HOME/.dockroot.d" "$HOME/drives.d" "$HOME/codespace.d/" "$HOME/applications.d/" "$HOME/.aliases.d/"
    do
      mkdir $key
      touch $key/lamebox.txt
    done
}


install_swappiness() {
  echo "Current swappiness:"
  cat /proc/sys/vm/swappiness
  echo vm.swappiness=20 >> /etc/sysctl.conf
}

install_ansible() {
  sudo apt update
  sudo apt install software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install ansible
}

install_all() {
    for key in "${!installers[@]}"
    do
      if [ "$key" != "all" ];
      then
        ${installers[$key]}
      fi
    done
}

install_snaps() {
  for snapapp in chromium dbeaver-ce prospect-mail teams-for-linux czkawka;
  do sudo snap install $snapapp; done
}

install_snaps_classic() {
 for snapapp in code standard-notes;
 do sudo snap install $snapapp --classic; done
 snap connect standard-notes:password-manager-service
}

executor() {
   if [ "$1" = "q" ]; then
        echo "exiting"
        exit;
      else
        eval ${installers[$1]}
        if [ $# -gt 0 ]
          then
            menu
        fi
   fi
}

menu() {
    echo "lame-box:"
    for key in "${!installers[@]}"
    do
        echo "  -  '$key'"
    done
    echo "type q to quit"
    read -p "type here:" installer_key
    executor $installer_key
}

if [ $# -eq 0 ]
  then
    menu
fi