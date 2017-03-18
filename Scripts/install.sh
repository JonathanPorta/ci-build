#!/bin/bash

if [ $TRAVIS_OS_NAME == "linux" ]; then
  echo 'linux'
elif [ $TRAVIS_OS_NAME == "linux" ]; then
  # Release details as of 2/24/17: http://download.unity3d.com/download_unity/3829d7f588f3/unity-5.5.2f1-osx.ini
  # Thanks to vergenzt for find this info. Writeup here: https://github.com/JonathanPorta/ci-build/pull/3#issue-132893904
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
    sudo installer -dumplog -package `basename "$package"` -target /
  }

  # See $BASE_URL/$HASH/unity-$VERSION-$PLATFORM.ini for complete list
  # of available packages, where PLATFORM is `osx` or `win`

  install "MacEditorInstaller/Unity-$VERSION.pkg"
  install "MacEditorTargetInstaller/UnitySetup-Windows-Support-for-Editor-$VERSION.pkg"
  install "MacEditorTargetInstaller/UnitySetup-Linux-Support-for-Editor-$VERSION.pkg"
else
  echo 'Unsupported OS'
fi
