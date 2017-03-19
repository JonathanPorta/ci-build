#!/bin/bash
# Source: https://github.com/JonathanPorta/ci-build/tree/master/Scripts/build.sh

project="ci-build"

if [[ $PLATFORM == "WINDOWS" ]]; then
  echo "Attempting to build $project for Windows"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildWindowsPlayer "$(pwd)/Build/windows/$project.exe" \
    -quit
elif [[ $PLATFORM == "MACOS" ]]; then
  echo "Attempting to build $project for macOS"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildOSXUniversalPlayer "$(pwd)/Build/osx/$project.app" \
    -quit
elif [[ $PLATFORM == "LINUX" ]]; then
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
fi

exit $?
