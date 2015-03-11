#! /bin/sh

/Applications/Unity/Unity.app/Contents/MacOS/Unity \
  -batchmode \
  -projectPath $(pwd) \
  -buildWindowsPlayer $(pwd)/Build/win64/ci-build.exe \
  -quit
