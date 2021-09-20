Mon Sep 20 14:22:45 UTC 2021
#!/bin/sh -l
#SBATCH --account=star
#SBATCH -o build-intel_2019.0.5_intelmpi_O.bat_%j.o
#SBATCH -e build-intel_2019.0.5_intelmpi_O.bat_%j.e
#SBATCH --time=2:00:00
#SBATCH --partition=s4
#SBATCH --qos=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --exclusive
export JOBID=$SLURM_JOBID

module load license_intel/S4
export ESMF_MPIRUN=mpirun.srun
module load intel/19.0.5 hdf hdf5 impi/19.0.5 netcdf4/4.7.3
module load hdf5/1.10.5 
module list >& module-build.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/scratch/users/mpotts/intel_2019.0.5_intelmpi_O_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make -j 24 2>&1| tee build_$JOBID.log

