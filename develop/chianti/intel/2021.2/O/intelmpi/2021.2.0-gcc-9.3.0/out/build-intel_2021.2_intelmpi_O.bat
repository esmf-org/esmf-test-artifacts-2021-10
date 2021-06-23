#!/bin/bash -l
export JOBID=12345
source /home/mpotts/spack/opt/spack/linux-linuxmint19-skylake/gcc-9.3.0/lmod-8.3-cvpunltgew3leifriqeq6n5wtduvd3ss/lmod/8.3/init/bash
module use /home/mpotts/hpc-modules/modulefiles/stack

module load hpc/1.1.0.a
module load hpc-intel-oneapi-compilers/2021.2.0-gcc-9.3.0 hpc-intel-oneapi-mpi/2021.2.0-gcc-9.3.0 netcdf-c/4.8.0-intel-2021.2.0 netcdf-fortran/4.5.3-intel-2021.2.0
module list >& module-build.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/home/mpotts/intel_2021.2_intelmpi_O_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make -j 8 2>&1| tee build_$JOBID.log

