#!/bin/bash

# Exit on failures
set -e
# Echo what runs
set -x

OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')
echo "====> OSX Version: ${OSX_VERS}"

if [ "$OSX_VERS" -eq 13 ]; then
    #DMGURL="https://artifactory.saltstack.net/artifactory/macos-files/Command_Line_Tools_macOS_10.13_for_Xcode_10.1.dmg"
    #TOOLS=clitools.dmg
    #curl -u$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD "$DMGURL" -o "$TOOLS"
    #TMPMOUNT=`/usr/bin/mktemp -d /tmp/clitools.XXXX`
    #hdiutil attach "$TOOLS" -mountpoint "$TMPMOUNT"
    #sudo installer -allowUntrusted -pkg "$(find $TMPMOUNT -name '*.pkg')" -target /
    #hdiutil detach "$TMPMOUNT"
    #rm -rf "$TMPMOUNT"
    #rm "$TOOLS"
    /usr/bin/sudo /usr/bin/xcode-select --print-path
    /usr/bin/sudo /usr/bin/touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    #/usr/bin/sudo /usr/sbin/softwareupdate -i Command\ Line\ Tools\ (macOS\ Highsiera\ version\ 10.13)\ for\ Xcode-10.1
    /usr/bin/sudo /usr/sbin/softwareupdate -i Command\ Line\ Tools\ \(macOS\ High\ Sierra\ version\ 10.13\)\ for\ Xcode-10.1
    /usr/bin/sudo /bin/rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    /usr/bin/sudo /usr/bin/xcode-select --print-path
    /usr/bin/sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
fi

if [ "$OSX_VERS" -eq 15 ]; then
    /usr/bin/sudo /usr/bin/xcode-select --reset
    os=$(sw_vers -productVersion | awk -F. '{print $1 "." $2}')
    if /usr/bin/sudo /usr/sbin/softwareupdate --history | grep --silent "Command Line Tools.*${os}.*"; then
        echo 'Command-line tools already installed.'
    else
        echo 'Installing Command-line tools...'
        in_progress=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        touch ${in_progress}
        product=$(/usr/bin/sudo /usr/sbin/softwareupdate --list | awk "/\* Command Line.*${os}.*/ { sub(/^   \* /, \"\"); print }")
        /usr/bin/sudo /usr/sbin/softwareupdate --verbose --install "${product}" || echo 'Installation failed.' 1>&2 && rm ${in_progress} && exit 1
        rm ${in_progress}
        echo 'Installation succeeded.'
    fi
fi

echo "====> Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
