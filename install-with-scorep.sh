#!/bin/bash
module purge

rm -rf build CMakeCache.txt CMakeFiles
# source /ccs/proj/gen010/tools/install/config/config-scorep-9.0-rc1-PrgEnv-amd-8.6.0-cpe-24.11-rocm-6.3.1-papi-master-17ded13a78c26988d3e8ff72daa130124aa02ed8/scorep-modules.sh

export ROCM_VERSION=6.4.1

module load libfabric/1.22.0 \
            perftools-base/24.11.0 \
            PrgEnv-amd/8.6.0 \
            cray-mpich/8.1.31 \
            amd/$ROCM_VERSION \
            rocm/$ROCM_VERSION \

source ../../setup-env.sh

echo "ROCM PATH: $ROCM_PATH"
echo "ROCM VERSION: $ROCM_VERSION"

export OpenMP_CC="scorep-cc"
export OpenMP_CXX="scorep-CC"

export CRAY_MPICH_PREFIX=$(dirname $(dirname $(which mpicc)))
export ROCHPL_ROOT=$(pwd)
export PREFIX=$ROCHPL_ROOT/install-scorep-amd
cd $ROCHPL_ROOT
rm -rf build
./backend-scorep-install-helper-script.sh \
   --with-rocm=${ROCM_PATH} \
   --with-rocblas=${ROCM_PATH} \
   --with-mpi=${CRAY_MPICH_PREFIX} \
   --with-cpublas=${CRAY_LD_LIBRARY_PATH}/libblas.so \
   --prefix=$PREFIX