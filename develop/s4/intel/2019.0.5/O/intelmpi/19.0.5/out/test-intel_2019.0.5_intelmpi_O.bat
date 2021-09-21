Tue Sep 21 17:30:58 UTC 2021
#!/bin/sh -l
#SBATCH --account=star
#SBATCH -o test-intel_2019.0.5_intelmpi_O.bat_%j.o
#SBATCH -e test-intel_2019.0.5_intelmpi_O.bat_%j.e
#SBATCH --time=2:30:00
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
module list >& module-test.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/scratch/users/mpotts/intel_2019.0.5_intelmpi_O_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
ssh s4-submit.ssec.wisc.edu /scratch/users/mpotts//scratch/users/mpotts/intel_2019.0.5_intelmpi_O_develop/getres-int.sh
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
chmod +x runpython.sh
cd nuopc-app-prototypes
./testProtos.sh 2>&1| tee ../nuopc_$JOBID.log 

ssh s4-submit.ssec.wisc.edu /scratch/users/mpotts//scratch/users/mpotts/intel_2019.0.5_intelmpi_O_develop/getres-int.sh
