#!/bin/bash -l
export JOBID=12345

module use /home/mpotts/hpc-modules/modulefiles/stack

module load hpc/1.1.0.a
module load hpc-intel-oneapi-compilers/2021.2.0-gcc-9.3.0 hpc-intel-oneapi-mpi/2021.2.0-gcc-9.3.0 netcdf/4.7.0
module list >& module-build.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/home/mpotts/intel_2021.2_intelmpi_g_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make -j 8 2>&1| tee build_$JOBID.log

