Tue Sep 14 15:53:52 MDT 2021
#!/bin/sh -l
#PBS -N test-pgi_20.4_openmpi_g.bat
#PBS -l walltime=4:00:00
#PBS -q regular
#PBS -A P93300606
#PBS -l select=1:ncpus=36:mpiprocs=36
JOBID="`echo $PBS_JOBID | cut -d. -f1`"

cd /glade/scratch/dunlap/esmf-testing/pgi_20.4_openmpi_g_develop
module load pgi/20.4 openmpi/4.0.5 netcdf/4.7.4
module list >& module-test.log

set -x
export ESMF_NETCDF=nc-config

export TMPDIR="/glade/scratch/dunlap/tmp"
export ESMF_DIR=/glade/scratch/dunlap/esmf-testing/pgi_20.4_openmpi_g_develop
export ESMF_COMPILER=pgi
export ESMF_COMM=openmpi
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
chmod +x runpython.sh
cd nuopc-app-prototypes
./testProtos.sh 2>&1| tee ../nuopc_$JOBID.log 

ssh cheyenne6 /glade/scratch/dunlap/esmf-testing/pgi_20.4_openmpi_g_develop/getres-test.sh
ssh cheyenne6 /glade/scratch/dunlap/esmf-testing/pgi_20.4_openmpi_g_develop/getres-test.sh
