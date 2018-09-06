#!/bin/bash 
# Simple Unix shell script to build Mercurial using Jenkins CI
# Designed to run under Cygwin as well. 

PROJECT="Mercurial Support"


# ### START OF common.sh.in ##########################################
#
# Common set of function to build a project. 
# 
 

# Determine operating system, bit simple but works
if [ "$OS" == "Windows_NT" ]; then
    WIN32=1
    UNIX=0
else
    WIN32=0
    UNIX=1
fi

# =====================================================
# Utility functions
# =====================================================


# Simple logging functions
function info {
    echo "[INF] $1"
    if [ ! -z "$2" ]; then
        echo "      $2"
    fi
}

function error {
    echo     "[ERR] $1"
    if [ ! -z "$2" ]; then
        echo "      $2"
    fi
    exit 1
}

# Run make in current directory. Caller should cd to target 
# directory before calling this method.
function mk {
    if [ "$WIN32" == "1" ]; then
    	cmd /C bmake.bat $1 $2
    else
    	if [ ! -f makefile ]; then
    	   if [ -f Makefile ]; then
    	   	make mf || error "Failed to generate makefile (make mf)"
    	   else
    	   	make -f Makefile.init mf || error "Failed to generate makefile (make -f Makefile.init mf)"
    	   fi
    	fi
    	make $1 $2 || error "Make failed"
    fi
}

# Run tests for package specified in first argument. 
function sunit {    
    pushd stx/goodies/builder/reports
    info "Running tests for $1"
    if [ "$WIN32" == "1" ]; then
        cmd /C report-runner.bat -D ../../../.. -r Builder::TestReport -p "$1" || error "Failed to run reports"
    else
        (echo "" | ./report-runner.sh -D ../../../.. -r Builder::TestReport -p "$1") || error "Failed to run reports"
    fi
    popd
}

# Main function. Performs complete build or given task
function main {
    pushd "$BUILD"
    if [ -z "$1" ]; then
    	info "Checking out..."
    	checkout
    	info "Compiling..."
    	compile
    	info "Running tests..."
    	runtests
    else
        case "$1" in
            checkout)
    	        info "Checking out..."
    	        checkout;;
            compile)
                info "Compiling..."
    	        compile;;
            tests)
    	        info "Running tests..."
    	        runtests;;
            test)
    	        info "Running tests..."
    	        runtests;;
            *)
                error "Invalid command ($1)"
        esac
    fi
    popd
    exit 0
}

# Setup...

if [ "$WIN32" == "1" ]; then
    # WINDOWS
    # MUST export this, otherwise libjpeg fails to build!!!"
    if [ -z "$BCB"]; then
        export BCB="C:\Borland\BCC55"
    fi
    # To make cvs/ssh happy
    if [ -z "$CVS_RSH" ]; then
        export CVS_RSH=plink
    fi
    # Set home
    export HOME=$USERPROFILE
else
    # LINUX
    # to get Mercurial on build slave
    export PATH=$PATH:/home/vrany/bin
fi

if [ -z "$CVSROOT" ]; then
    error "CVSROOT not set!"
fi

# Sorry, it's lot easier for all to have all the messages in EN :-)
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

BUILD="."


echo "INFO: BUILD=\"$BUILD\""

if [ -d "$BUILD" ]; then
    if [ "$BUILD" != "." ]; then
        info "Build directory already exists!"
    fi
else
    mkdir -p "$BUILD"
fi


# ===================================================================
# Actual build functions. 
# ===================================================================
#
# User scripts should override following functions to define a build

function checkout {
    error "You have to override function 'checkout'"
}

function compile {
    error "You have to override function 'compile'"
}

function runtests {
    info "No tests specified" "To do so, override function runtests"
}

# ### END OF common.sh.in ############################################

# Checkout
function checkout {
    # Checkout stx
    if [ ! -d stx ]; then
      if ! cvs co stx; then
        error "CVS: Cannot checkout stx";
      fi
    #else
    #  (cd stx && cvs update -d)
    fi

    # Checkout stx:libscm
    repo="https://bitbucket.org/janvrany/stx-libscm"
    if [ ! -d stx/libscm ]; then
        hg clone "$repo" stx/libscm || error "HG: cannot clone stx:libscm"
    else
        hg --cwd stx/libscm pull "$repo" || error "HG: cannot pull stx:libscm"
        hg --cwd stx/libscm update || error "HG: cannot update stx:libscm"
    fi
}


# Compile
function compile {
    TARGETS1="stx stx/libscm/common stx/libscm/mercurial stx/librun"
    for target in $TARGETS1; do
      if ! (cd "$target" && mk); then
        echo "ERROR:  cannot $MAKE in $target"
        exit 3
      fi
    done
}

function runtests {
    sunit "stx:libscm/mercurial"
}


# Now, call main
main $1 $2 $3
