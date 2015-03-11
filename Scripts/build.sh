#! /bin/sh

echo 'Attempting to build project.'
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -silent-crashes
  -logFile $(pwd)/unity.log
  -projectPath $(pwd) \
  -buildWindowsPlayer $(pwd)/Build/win64/ci-build.exe \
  -quit

echo 'Logs from build'
cat $(pwd)/unity.log
