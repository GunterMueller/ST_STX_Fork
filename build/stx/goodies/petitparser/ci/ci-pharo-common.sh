#
# A set of functions to be used in PetitParser's Pharo CI jobs
#

if [ ! -f "ci-common.sh" ]; then
    wget -O "ci-common.sh" https://bitbucket.org/janvrany/stx-goodies-petitparser/raw/tip/ci/ci-common.sh
fi
. ci-common.sh


IMAGE_BASE=PetitParser-$BUILD_NUMBER
IMAGE=$IMAGE_BASE.image

# A function to download Pharo. The version of Pharo 
# is taken from environment variable PHARO. If it's not
# defined, defaults to  Pharo 5.0 
function ci_pharo_download_pharo {
    if [ -z "$PHARO" ]; then
        PHARO=5.0
    fi

    if [ ! -x pharo-ui ]; then
        rm -rf pharo pharo-ui pharo-vm Pharo.image Pharo.changes
	case "$PHARO" in 
            5.0)
                wget -O- get.pharo.org/50+vm | bash
                ;;	

            4.0)
                wget -O- get.pharo.org/40+vm | bash
                ;;	
            3.0)
                wget -O- get.pharo.org/30+vm | bash
                ;;	
            *)
                echo "Unknown PHARO version: $PHARO"
                exit 1
        esac
    fi
}

# A function to download PetitCompiler and build an image

function ci_pharo_download_petitparser {
    ./pharo Pharo.image save $IMAGE_BASE
    ./pharo $IMAGE config http://smalltalkhub.com/mc/JanVrany/CalipeL-S/main ConfigurationOfCalipeLS --install=0.1
    ./pharo $IMAGE eval --save "

    Gofer new smalltalkhubUser: 'JanKurs' project: 'PetitParser';
        configurationOf: #PetitCompiler; load.
    (Smalltalk at: #ConfigurationOfPetitCompiler) perform: #'loadDevelopment'.
    "
}

