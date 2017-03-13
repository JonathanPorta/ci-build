#! /bin/sh

project="ci-build"

echo "Attempting to build $project for Windows"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile /dev/stdout \
  -projectPath $(pwd) \
  -buildWindowsPlayer "$(pwd)/Build/windows/$project.exe" \
  -quit
  
exitcode="$?"
if [ $exitcode != 0 ]; then
  echo "Build failed!"
  exit "$exitcode"
fi

echo "Attempting to build $project for OS X"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile /dev/stdout \
  -projectPath $(pwd) \
  -buildOSXUniversalPlayer "$(pwd)/Build/osx/$project.app" \
  -quit

exitcode="$?"
if [ $exitcode != 0 ]; then
  echo "Build failed!"
  exit "$exitcode"
fi

echo "Attempting to build $project for Linux"
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -nographics \
  -silent-crashes \
  -logFile /dev/stdout \
  -projectPath $(pwd) \
  -buildLinuxUniversalPlayer "$(pwd)/Build/linux/$project" \
  -quit
  
exitcode="$?"
if [ $exitcode != 0 ]; then
  echo "Build failed!"
  exit "$exitcode"
fi
