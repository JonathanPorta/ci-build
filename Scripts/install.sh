#!/bin/bash

# Release details and list of available packages as of 2/24/17:
# - http://download.unity3d.com/download_unity/3829d7f588f3/unity-5.5.2f1-osx.ini
# - http://download.unity3d.com/download_unity/3829d7f588f3/unity-5.5.2f1-win.ini
# - also at $BASE_URL/$HASH/unity-$VERSION-$PLATFORM.ini
# Thanks to vergenzt for find this info. Writeup here: https://github.com/JonathanPorta/ci-build/pull/3#issue-132893904
# More manual install details at https://docs.unity3d.com/Manual/InstallingUnity.html
BASE_URL=http://netstorage.unity3d.com/unity
HASH=3829d7f588f3
VERSION=5.5.2f1

download() {
  file=$1
  url="$BASE_URL/$HASH/$package"

  echo "Downloading from $url: "
  curl -o `basename "$package"` "$url"
}

install() {
  package=$1
  download "$package"

  echo "Installing "`basename "$package"`
  if [[ $TRAVIS_OS_NAME == "osx" ]]; then
    sudo installer -dumplog -package `basename "$package"` -target /
  else
    echo 'todo: add windows support'
    dir
    eval `basename "$package"` /S
  fi
}

if [[ $TRAVIS_OS_NAME == "osx" ]]; then
  echo 'Installing Unity on macOS'

  install "MacEditorInstaller/Unity.pkg"
  install "MacEditorTargetInstaller/UnitySetup-Windows-Support-for-Editor-$VERSION.pkg"
  install "MacEditorTargetInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.pkg"
elif [[ $APPVEYOR == "True" ]]; then
  echo 'Installing Unity on Windows'

  install "Windows64EditorInstaller/UnitySetup64.exe"
  install "TargetSupportInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.exe"
  install "TargetSupportInstaller/UnitySetup-Mac-Support-for-Editor-$VERSION.exe"
elif [[ $TRAVIS_OS_NAME == "linux" ]]; then
  # Linux install is a bit different
  # latest Linux Unity details can be found at https://forum.unity3d.com/threads/unity-on-linux-release-notes-and-known-issues.350256/
  echo 'Installing Unity on Linux'
  echo 'Install Mono'
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
  sudo apt-get update

  curl -o unity.deb http://beta.unity3d.com/download/b9488c3b1f9f/unity-editor_amd64-5.6.0xb10Linux.deb
  # from http://askubuntu.com/a/841240/310789
  echo 'try first install'
  sudo dpkg -i unity.deb
  echo 'install dep'
  sudo apt-get install -f
  echo 'try second install'
  sudo dpkg -i unity.deb
  #curl -o `basename install-linux.sh` http://beta.unity3d.com/download/e06241adb51f/unity-editor-installer-5.5.2xf1Linux.sh
  #./install-linux.sh
else
  echo 'Unsupported OS'
  exit -1
fi
