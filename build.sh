#!/bin/bash
SCRIPT_PATH=$(dirname $(realpath $0))

# exit when any command fails
set -e

readonly BUILD_PATH=${SCRIPT_PATH}/build
readonly BENCHMARKS="2mm 3mm adi atax bicg cholesky correlation covariance deriche doitgen durbin fdtd-2d floyd-warshall gemm gemver gesummv gramschmidt heat-3d jacobi-1d jacobi-2d lu ludcmp mvt nussinov seidel-2d symm syr2k syrk trisolv trmm"

. /emsdk/emsdk_env.sh
cd $SCRIPT_PATH
mkdir -p $BUILD_PATH
for b in $BENCHMARKS; do
	src=`find . -name $b.c`
	dir=`dirname $src`
	echo "emcc -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 $size -O3 -I utilities -I $dir utilities/polybench.c $src -DPOLYBENCH_TIME -lm -o $BUILD_PATH/$b.js.."
	emcc -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 $size -O3 -I utilities -I $dir utilities/polybench.c $src -DPOLYBENCH_TIME -lm -o $BUILD_PATH/$b.js
done
