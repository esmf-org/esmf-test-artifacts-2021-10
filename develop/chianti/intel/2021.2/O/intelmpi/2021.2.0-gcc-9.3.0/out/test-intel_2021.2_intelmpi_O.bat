#!/bin/bash -l
export JOBID=12346

module use /home/mpotts/hpc-modules/modulefiles/stack

module load hpc/1.1.0.a
module load hpc-intel-oneapi-compilers/2021.2.0-gcc-9.3.0 hpc-intel-oneapi-mpi/2021.2.0-gcc-9.3.0 netcdf/4.7.0
module list >& module-test.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/home/mpotts/intel_2021.2_intelmpi_O_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
