#!/bin/bash

# Simple Unix shell script to build STX:LIBJAVA using Jenkins CI
# Actually, it is used on Windows (with UnxUtils) as well.

PROJECT="STX_LIBJAVA"

# Determine operating system, bit simple but works
if [ "$OS" == "Windows_NT" ]; then
    WIN32=1
    UNIX=0
else
    WIN32=0
    UNIX=1
fi

# Setup...
if [ "$WIN32" == "1" ]; then
    # WINDOWS
    # MUST export this, otherwise libjpeg fails to build!!!"
    export BCB="C:\Borland\BCC55"
    # To make cvs/ssh happy
    export CVS_RSH=plink
    # Set home
    export HOME=$USERPROFILE
    # Defaults
    export CVSROOT=":pserver:jenkinsBuild:blablu@cvs.bh.exept.de:/cvs/stx"
    # Make using bmake here..."
    MAKE="cmd /C bmake.bat"
else
    # LINUX
    # to get Mercurial
    export PATH=$PATH:/home/vrany/bin
    if [ $(uname -n) == 'exeptn' ]; then
    	# On exeptn, default Java is 1.4, sigh
    	export PATH=/usr/java/jdk1.7.0_13/bin:$PATH
    fi

    # Make using regular make here..."
    MAKE=make
    # Defaults
    export CVSROOT="/cvs/stx"
fi



# Sorry, it's lot easier for JV to have all the messages in EN :-)
export LANG=en_GB.UTF-8


# When run interactively, Jenkins env variables
# may not be set...
if [ -z "$WORKSPACE" ]; then
  WORKSPACE="$PWD"
    INTERACTIVE=1
else
    INTERACTIVE=0
fi

if [ "$INTERACTIVE" == "0" ]; then
  if [ "$WIN32" == "1" ]; then
    WORKSPACE="$PWD"
  fi
fi

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER=$(date +%Y_%m_%d_interactive)
fi

#BUILD="$WORKSPACE/${PROJECT}_${BUILD_NUMBER}_linux_build"
BUILD="build"


echo "INFO: BUILD=\"$BUILD\""

if [ -d "$BUILD" ]; then
  echo "WARN: Build directory already exists!"
else
    mkdir -p "$BUILD"
fi

pushd "$BUILD"

function checkout_hg {
	local directory=$1
	local repository=$2
	local branch=$3

	if [ -z "$branch" ]; then
		branch=default
	fi

    if [ -d "$directory/CVS" ]; then
      rm -rf "$directory"
    fi

    if [ ! -d "$directory" ]; then
      if ! hg clone "$repository" "$directory" -b "$branch";  then
        echo "ERROR: HG: Cannot clone $directory";
        exit;
      fi
    else
      if ! hg --cwd "$directory" pull;  then
        echo "ERROR: HG: Cannot pull $directory";
        exit;
      fi
      if ! hg --cwd "$directory" update;  then
        echo "ERROR: HG: Cannot update $directory";
        exit;
      fi
    fi

}


if [ -z "$SKIP_CHECKOUT" ]; then

    echo "INFO: Checking out source code"

    # Checkout stx
    if [ ! -d stx ]; then
      if ! cvs co stx; then
        echo "ERROR: CVS: Cannot checkout stx";
        exit;
      fi
    else
      (cd stx && cvs update -d)
    fi

    checkout_hg stx/stc /home/vrany/repositories/hg/stx.stc jv
    checkout_hg stx/librun /home/vrany/repositories/hg/stx.librun jv

    # stx:libjava repo is huge, so first update from local cache
    # and then fetch updates from BitBucket.  
    if [ $(uname -n) == 'exeptn' ]; then
       checkout_hg stx/libjava /home/vrany/repositories/hg/stx.libjava development
    fi
    checkout_hg stx/libjava https://janvrany@bitbucket.org/janvrany/stx-libjava development

else
    echo "INFO: Checkout skipped (SKIP_CHECKOUT=$SKIP_CHECKOUT)"
fi

# Compile

if [ -z "$SKIP_COMPILE" ]; then

    if [ "$UNIX" == "1" ]; then
	if [ ! -f stx/configurations/myConf ]; then
	    (cd stx && ./CONFIG)
	fi
	# Hack...
        if [ ! -f stx/stc/makefile ]; then
            (cd stx/stc && ../rules/stmkmf)
        fi
        if [ ! -f stx/librun/makefile ]; then
            (cd stx/librun && ../rules/stmkmf)
        fi
    fi

    echo "INFO: Compiling"
    TARGETS1="stx stx/libjava stx/goodies/petitparser stx/libjava/tools stx/libjava/experiments stx/projects/smalltalk stx/librun"
    for target in $TARGETS1; do
      if ! (cd "$target" && $MAKE); then
        echo "ERROR:  cannot $MAKE in $target"
        exit 3
      fi
    done

else
    echo "INFO: Compilation skipped (SKIP_COMPILE=$SKIP_COMPILE)"
fi

popd

echo "INFO: $PROJECT SUCCESSFULLY BUILT"
