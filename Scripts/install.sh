#!/bin/bash
# Source: https://github.com/JonathanPorta/ci-build/tree/master/Scripts/install.sh

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
  else # assume installing windows package
    eval ./`basename "$package"` /S
  fi
}

if [[ $TRAVIS_OS_NAME == "osx" ]]; then
  echo 'Installing Unity on macOS'

  if [[ -d "/Applications/Unity/Unity.app" ]]; then
    echo 'Already installed'
  else
    install "MacEditorInstaller/Unity.pkg"
    install "MacEditorTargetInstaller/UnitySetup-Windows-Support-for-Editor-$VERSION.pkg"
    install "MacEditorTargetInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.pkg"
  fi
elif [[ $APPVEYOR == "True" ]]; then
  echo 'Installing Unity on Windows'

  install "Windows64EditorInstaller/UnitySetup64.exe"
  install "TargetSupportInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.exe"
  install "TargetSupportInstaller/UnitySetup-Mac-Support-for-Editor-$VERSION.exe"
elif [[ $TRAVIS_OS_NAME == "linux" ]]; then
  # Linux install is a bit different
  # latest Linux Unity details can be found at https://forum.unity3d.com/threads/unity-on-linux-release-notes-and-known-issues.350256/
  echo 'Installing Unity on Linux'

  echo "travis_fold:start:install_unity"
  echo 'Installing Unity'
  curl -o unity.deb http://beta.unity3d.com/download/b9488c3b1f9f/unity-editor_amd64-5.6.0xb10Linux.deb
  sudo dpkg -i unity.deb
  echo "travis_fold:end:install_unity"

  # from http://askubuntu.com/a/841240/310789
  echo "travis_fold:start:install_missing_dependencies"
  echo 'Installing missing dependencies'
  sudo apt-get install -f
  echo "travis_fold:end:install_missing_dependencies"
else
  echo 'Unsupported OS'
  exit -1
fi
