#!/bin/bash

project="ci-build"

if [ $PLATFORM == "WINDOWS" ]; then
  echo "Attempting to build $project for Windows"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildWindowsPlayer "$(pwd)/Build/windows/$project.exe" \
    -quit

  exitcode="$?"
  if [ $exitcode != 0 ]; then
    echo "Build failed!"
    exit "$exitcode"
  fi
fi

if [ $PLATFORM == "MACOS" ]; then
  echo "Attempting to build $project for macOS"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildOSXUniversalPlayer "$(pwd)/Build/osx/$project.app" \
    -quit

  exitcode="$?"
  if [ $exitcode != 0 ]; then
    echo "Build failed!"
    exit "$exitcode"
  fi
fi

if [ $PLATFORM == "LINUX" ]; then
  echo "Attempting to build $project for Linux"
  ./Scripts/unity_stdout.sh \
    -batchmode \
    -nographics \
    -silent-crashes \
    -projectPath $(pwd) \
    -buildLinuxUniversalPlayer "$(pwd)/Build/linux/$project" \
    -quit

  exitcode="$?"
  if [ $exitcode != 0 ]; then
    echo "Build failed!"
    exit "$exitcode"
  fi
fi
