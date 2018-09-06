#!/bin/bash
# 
# a CI job to run PetitCompiler benchmarks on Pharo
#
set -e

if [ ! -f "ci-pharo-common.sh" ]; then
    wget -O "ci-pharo-common.sh" https://bitbucket.org/janvrany/stx-goodies-petitparser/raw/tip/ci/ci-pharo-common.sh
fi
. ci-pharo-common.sh

ci_download_test_data

ci_pharo_download_pharo
ci_pharo_download_petitparser

set +e
./pharo $IMAGE benchmark --tag PetitParser --setup "Author fullName:'Jenkins'" --json -o $PETITCOMPILER_BENCHMARK_REPORT PPCCalipelBenchmark;
status=$?
set -e

ci_upload_benchmark_results

exit $status


