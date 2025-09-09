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
# export SCOREP_EXPERIMENT_DIRECTORY="latest_cug_scorep_sgemm_scorep_papi_frontier-x86_power_energy"
# export SCOREP_ENABLE_PROFILING=false
# export SCOREP_ENABLE_TRACING=true
# export SCOREP_TOTAL_MEMORY=200M


# # Handle dispatch mode
# export SCOREP_METRIC_PLUGINS="arocm_smi_plugin,coretemp_plugin"
# # export SCOREP_METRIC_PLUGINS="arocm_smi_plugin"
# export SCOREP_METRIC_AROCM_SMI_PLUGIN="rocm_smi:::energy_count:device=0,rocm_smi:::energy_count:device=2,rocm_smi:::energy_count:device=4,rocm_smi:::energy_count:device=6"
# export SCOREP_METRIC_ACRAYPM_PLUGIN="coretemp:::craypm:accel0_energy,coretemp:::craypm:accel0_power,coretemp:::craypm:accel1_energy,coretemp:::craypm:accel1_power,coretemp:::craypm:accel2_energy,coretemp:::craypm:accel2_power,coretemp:::craypm:accel3_energy,coretemp:::craypm:accel3_power"


# export SCOREP_METRIC_AROCM_SMI_INTERVAL_US=1000
# export SCOREP_METRIC_ACRAYPM_INTERVAL_US=1000
# export SCOREP_METRIC_APAPI_INTERVAL_US=1000
# export SCOREP_X86_ENERGY_PLUGIN_INTERVALL_US=1000
# export SCOREP_METRIC_X86_ENERGY_PLUGIN_OFFSET=0

# Change directory to the script's location
cd "$(dirname "$0")"

export OpenMP_CC=scorep-cc
export OpenMP_CXX=scorep-CC
export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
export CRAY_MPICH_PREFIX=$(dirname $(dirname $(which mpicc)))
export ROCHPL_ROOT=$(pwd)

export MPICH_GPU_SUPPORT_ENABLED=1
export LD_LIBRARY_PATH=$ROCHPL_ROOT/tpl/blis/lib/:$LD_LIBRARY_PATH
# export SCOREP_EXPERIMENT_DIRECTORY=$ROCHPL_ROOT/scorep-amd-results
echo "ScoreP at $SCOREP_EXPERIMENT_DIRECTORY"

srun -A gen010 -t10 -N 2 --ntasks-per-node=1 --gpu-bind=closest $ROCHPL_ROOT/install-scorep-amd/bin/rochpl -P 1 -Q 2 -N 90112 --NB 512
# $ROCHPL_ROOT/install-scorep-amd/mpirun_rochpl -P 1 -Q 1 -N 64512 --NB 512