#!/bin/bash
# 
# a CI job to run PetitCompiler tests on Pharo
#
set -e

if [ ! -f "ci-pharo-common.sh" ]; then
    wget -O "ci-pharo-common.sh" https://bitbucket.org/janvrany/stx-goodies-petitparser/raw/tip/ci/ci-pharo-common.sh
fi
. ci-pharo-common.sh

ci_download_test_data

ci_pharo_download_pharo
ci_pharo_download_petitparser

rm -rf Petit*Test.xml
# Must turn off errexit option, Pharo return non-zero
# status when one or more tests fail. 
set +e
./pharo $IMAGE test --junit-xml-output  \
    PetitTests                          \
    PetitAnalyzer                       \
    PetitSmalltalk                      \
    PetitJava                           \
    PetitIslands                        \
    PetitCompiler-Tests                 \
    PetitCompiler-Extras-Tests		
set -e
