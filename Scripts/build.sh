#!/bin/bash
# Source: https://github.com/JonathanPorta/ci-build/tree/master/Scripts/build.sh

project="ci-build"

if [[ $PLATFORM == "WINDOWS" ]]; then
  echo "travis_fold:start:build_windows"
  echo "Attempting to build $project for Windows"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildWindowsPlayer "$(pwd)/Build/windows/$project.exe" \
    -quit
  exitcode="$?"
  echo "travis_fold:end:build_windows"
elif [[ $PLATFORM == "MACOS" ]]; then
  echo "travis_fold:start:build_macos"
  echo "Attempting to build $project for macOS"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildOSXUniversalPlayer "$(pwd)/Build/osx/$project.app" \
    -quit
  exitcode="$?"
  echo "travis_fold:end:build_macos"
elif [[ $PLATFORM == "LINUX" ]]; then
  echo "travis_fold:start:build_linux"
  echo "Attempting to build $project for Linux"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -username $unity_username \
    -password $unity_password \
    -force-opengl \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildLinuxUniversalPlayer "$(pwd)/Build/linux/$project" \
    -quit
  exitcode="$?"
  echo "travis_fold:end:build_linux"
fi

exit "$exitcode"
