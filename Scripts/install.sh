#! /bin/sh

echo 'Downloading from http://netstorage.unity3d.com/unity/5b98b70ebeb9/MacEditorInstaller/Unity.pkg'
curl -O http://netstorage.unity3d.com/unity/5b98b70ebeb9/MacEditorInstaller/Unity.pkg

echo 'Installing Unity.pkg'
sudo installer -dumplog -package Unity.pkg -target /
