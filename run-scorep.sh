# source ./config-scorep.sh

export ROCM_VERSION=6.4.1



module load libfabric/1.22.0 \
            perftools-base/24.11.0 \
            PrgEnv-amd/8.6.0 \
            amd/$ROCM_VERSION \
            cray-mpich/8.1.31 \
            rocm/$ROCM_VERSION \

source ../../setup-env.sh

source ../setup-run-params.sh

echo "ROCM PATH: $ROCM_PATH"
echo "ROCM VERSION: $ROCM_VERSION"

cd "$(dirname "$0")"

export ROCHPL_ROOT=$(pwd)

export MPICH_GPU_SUPPORT_ENABLED=1
export MPICH_OFI_NIC_POLICY=GPU
export FI_PROVIDER=cxi
export MPIR_CVAR_CH4_IPC_P2P=1
export MPIR_CVAR_CH4_IPC_GPU_HANDLE_MTYPE=hip

echo "ScoreP experiment results at $SCOREP_EXPERIMENT_DIRECTORY"
if [ ! -d $SCOREP_EXPERIMENT_DIRECTORY ]; then
  mkdir -p $SCOREP_EXPERIMENT_DIRECTORY
fi
srun -A gen010 -t10 -N 2 --ntasks-per-node=1 --gpu-bind=closest $ROCHPL_ROOT/install-scorep-amd/bin/rochpl -P 1 -Q 2 -N 90112 --NB 512