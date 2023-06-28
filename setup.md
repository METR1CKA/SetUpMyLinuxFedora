# MANUAL

1. Modificar carga de repos
  - sudo nano /etc/dnf/dnf.conf
  - [dnf.config.txt](./dnf.conf.txt)

2. Limpiar cache
  - sudo dnf clean all

3. Actualizar repos
  - sudo dnf update -y && sudo dnf upgrade -y

4. Habilitar RPM fusion
  - sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  - sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

  - sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  - sudo dnf groupupdate core

5. Añadir flatpak

  - flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

6. Modificar el hostname (opcional)

  - sudo hostnamectl set-hostname "Nombre"

7. Codecs

  - sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel

  - sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

  - sudo dnf groupupdate sound-and-video

8. Instalar cosas necesarias (opcional y a desicion)
