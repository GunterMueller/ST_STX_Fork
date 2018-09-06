#!/bin/bash

OUTPUT_DIR=`pwd`

help() {
    echo "Binary Dumper dumps detailed information about the given Java classes."
    echo "The classes can be specified by their names or by paths to .jar files."
    echo
    echo "Parameters:"
    echo "	-h, --help		print help for this script"
    echo "	-o, --outputdir <dir>	specify the directory for the output (if not specified the current directory is used)"
    echo ""
    echo "EXAMPLE:"
    echo "./binary_dumper -o ./test java.lang.Object /path/to/file.jar java.lang.String"
    echo "(Dumps Object, String and classes from file.jar to the ./test directory.)"
    echo ""
    exit 0
}

# Run the Binary Dumper
run() {
	echo "Starting Binary Dumper"
	echo "Output directory is: ${OUTPUT_DIR}"
	java -cp java/bin:java/libs/org.eclipse.jdt.core_3.8.3.v20130121-145325.jar stx.libjava.tools.environment.utils.BinaryDumper $OUTPUT_DIR $@
}

if [[ $1 == "--help" || $1 == "-h" ]]; then
    help
fi

if [[ $1 == "--outdir" || $1 == "-o" ]]; then
    OUTPUT_DIR=$2
    shift
	shift
fi

if [[ -z "$1" ]]; then
    echo "No classes to dump. Specify them as a space separated list of arguments (see the --help or -h)"
	exit
fi

run "$@"


