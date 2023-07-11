#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

DNF_CONF="./dnf.conf.txt"

# Cancelar procesos
ctrl_c() {
  echo -e "\n${redColour}[!] Cancelando procesos...${endColour}"
  exit
}

# Tiempo de espera
slp() {
  sleep 2
}

# Modificar carga de repos
mod_repos() {
  echo -e "\n${blueColour}[*] Añadiendo configuraciones a dnf${endColour}"
  slp
  content=$(cat "$DNF_CONF")
  echo "$content" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
  echo -e "\n${greenColour}[+] Contenido añadido al archivo${endColour}"
}

# Actualización de repos
update_upgrade() {
  echo -e "\n${blueColour}[*] Limpiando cache${endColour}"
  sudo dnf clean all
  echo -e "\n${blueColour}[*] Actualizando repositorios${endColour}"
  sudo dnf check-update
  sudo dnf update -y && sudo dnf upgrade -y
  echo -e "\n${greenColour}[+] Repositorios actualizados${endColour}"
}

rpm_fusion() {
  echo -e "\n${blueColour}[*] Habilitando RPM fusion${endColour}"
  sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  echo -e "\n${blueColour}[*] Actualizando grupo${endColour}"
  sudo dnf groupupdate core
  echo -e "\n${greenColour}[+] RPM Habilitado${endColour}"
}

ch_hostname() {
  echo -e "\n${blueColour}[+] ¿Desea modificar el hostname?${endColour}\n"
  read -p "(s/n): " option
  if [[ $option == "s" || $option == "S" ]]
  then
    echo -e "\n${greenColour}[+] Ingrese el nuevo nombre del host${endColour}\n"
    read -p "Nombre: " name
    sudo hostnamectl set-hostname $name
    echo -e "\n${greenColour}[+] Hostname modificado con exito${endColour}"
  elif [[ $option == "n" || $option == "N" ]]
  then
    echo -e "\n${yellowColour}[!] Hostname no modificado, omitiendo proceso${endColour}"
  else
    echo -e "\n${redColour}[x] Opcion no valida, omitiendo proceso${endColour}"
  fi
}

codecs() {
  echo -e "\n${blueColour}[*] Instalando codecs multimedia${endColour}"
  sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
  sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
  echo -e "\n${greenColour}[+] Codecs instalados con exito${endColour}"
}

# Permisos root
if [ "$(id -u)" != "0" ]
then
  echo -e "\n${redColour}[x] No eres usuario root...${endColour}"
  exit
fi

# Init process
slp
echo -e "\n${yellowColour}[!] Iniciando procesos${endColour}"
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
mod_repos
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
update_upgrade
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
rpm_fusion
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
ch_hostname
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
codecs
slp
echo -e "\n${grayColour}----------------------------------------${endColour}"
echo -e "\n${greenColour}[+] Proceso terminado${endColour}"
echo -e "\n${grayColour}----------------------------------------${endColour}"
exit 0
