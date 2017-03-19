#!/bin/bash

# Display Unity stdout on command line
# Run using normal options from https://docs.unity3d.com/Manual/CommandLineArguments.html like
#   ./unity_stdout.sh -batchmode -quit -projectPath \"$(pwd)\" -buildWindows64Player \"build.exe\"
# Initial idea from http://answers.unity3d.com/questions/19566/command-line-feedback.html#answer-155941
# Source: https://github.com/JonathanPorta/ci-build/tree/master/Scripts/unity_stdout.sh

# if UNITY not set via environment variable, set it
if [ -z ${UNITY+x} ]; then
  if hash unity 2>/dev/null; then # if unity command found, use that
    UNITY=unity
    onpath=true
  else
    #todo: set based on platform
    UNITY=/opt/Unity/Editor/Unity
    #UNITY=/Applications/Unity/Unity.app/Contents/MacOS/Unity
    #UNITY=/c/Program\ Files/Unity/Editor/Unity.exe
  fi
fi

# try to remove quotes from variable - needed if environment variable set using quotes
unitytemp=`eval printf $UNITY`

# if unitytemp still contains Unity file set it as path
# convert to lowercase before check
if [[ ${unitytemp,,} == *"unity"* ]]; then
  UNITY=$unitytemp
fi

if [[ ! -f "$UNITY" ]] && [[ $onpath != "true" ]]; then
  echo "Unity does not exist at '$UNITY'"
  echo "Set via UNITY environment variable (e.g. export UNITY=/path/to/Unity.exe)"
  exit -1
fi

# if /dev/stdout is symlink use that for output otherwise use tail method
if [[ -L /dev/stdout ]]; then
  sudo apt-get install glxgears
  sudo glxgears
  echo "Using /dev/stdout"
  #todo: not sudo for other systems
  sudo $UNITY $@ -logFile /dev/stdout
  sudo xvfb-run --server-args="-screen 0 1024x768x24" $UNITY $@ -logFile /dev/stdout -force-opengl
  exitcode="$?"
else
  # get unique file to use for temp log file
  log=`mktemp unity_stdout.XXXX.tmp -u`
  echo "Using $log"

  tail -F $log 2> /dev/null &
  eval "\"$UNITY\" $@ -logFile $log"
  exitcode="$?"
  sleep 5s # wait for tail to catchup
  kill %1 # stop tailing
  wait %1 2> /dev/null # hide terminated message
  rm $log 2> /dev/null
fi

if [[ $exitcode != 0 ]]; then
  echo "Failed!"
fi

exit "$exitcode"
