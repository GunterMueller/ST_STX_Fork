#
# A set of functions to be used in PetitParser's CI jobs
#

# Set up some environment variables (if not set by CI)
if [ -z "$BUILD_NUMBER" ]; then
   BUILD_NUMBER=0
fi

# Environment variable PETITCOMPILER_DATA_DIRECTORY
# should point to the directory where test data are
# stored (or where they should be downloaded and 
# unpacked. To save bandwidth and disk space, when run
# on (CTU FIT) Jenkins, point them to the shared directory

case $(uname -n) in
  swing-h-win64)
    export PETITCOMPILER_DATA_DIRECTORY="E:\\workspace\\petitcompiler_test_data"
    ;;
  swing-hudson-lin64)
    export PETITCOMPILER_DATA_DIRECTORY="/ws/workspace/petitcompiler_test_data"
    ;;
  *)
    export PETITCOMPILER_DATA_DIRECTORY=test-data
    ;;
esac 
PETITCOMPILER_BENCHMARK_REPORT=benchmark-results-$BUILD_NUMBER.json


function ci_download_and_unzip_file {
  local url=$1
  local where=$PETITCOMPILER_DATA_DIRECTORY
  local file=${url##*/}
  local directory=${file%.zip}
  local status=0

  if [ ! -d "$where/$directory" ]; then
    pushd "$where"
      wget -O "$file" "$url"
      set +e
      unzip -o "$file"
      status=$?
      set -e
      case "$status" in
        0)
          status=0
          ;;
        1)
          status=0
          ;;
        2)
          status=0
          ;;
        *)
          ;;
      esac
      # This is weird, but on Windows, sometimes I got
      # exit code 50 from unzip even though there's plenty
      # of space. To workaround, simply ignore it here, sigh.
      if [ "$OS" == "Windows_NT" ]; then
	if [ "$status" == "50" ]; then
	  status=0
	fi
      fi	
      rm -f "$file"
    popd
  else
    echo "Skipped $directory (already present)"
  fi
  return "$status"
}

function ci_download_test_data {
	if [ ! -x "$PETITCOMPILER_DATA_DIRECTORY" ]; then
		mkdir -p "$PETITCOMPILER_DATA_DIRECTORY"
	fi
	ci_download_and_unzip_file http://scg.unibe.ch/download/jk/petit-compiler/java-src.zip
	ci_download_and_unzip_file http://scg.unibe.ch/download/jk/petit-compiler/smalltalk-src.zip
	ci_download_and_unzip_file http://scg.unibe.ch/download/jk/petit-compiler/ruby-src.zip
	ci_download_and_unzip_file http://scg.unibe.ch/download/jk/petit-compiler/python-src.zip
}

function ci_upload_benchmark_results {
	if [ -f "$PETITCOMPILER_BENCHMARK_REPORT" ]; then
  		curl 'https://swing.fit.cvut.cz/calipel/imports/push-import'  \
		    --user "$CALIPEL_USER:$CALIPEL_PASSWORD" \
		    --compressed \
		    -H 'Content-Type: application/json' \
		    --data "@$PETITCOMPILER_BENCHMARK_REPORT"
	fi
}
