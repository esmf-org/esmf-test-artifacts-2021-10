Mon Sep 27 04:06:12 GMT 2021
#!/bin/sh -l
#SBATCH --account=hfv3gfs
#SBATCH -o test-intel_2020.2_intelmpi_O.bat_%j.o
#SBATCH -e test-intel_2020.2_intelmpi_O.bat_%j.e
#SBATCH --time=2:00:00
#SBATCH --partition=xjet
#SBATCH --qos=batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --exclusive
export JOBID=$SLURM_JOBID
module load intel/2020.2 impi/2020.2 netcdf/4.7.0
module load hdf5/1.10.6 
module list >& module-test.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/intel_2020.2_intelmpi_O_develop
export ESMF_COMPILER=intel
export ESMF_COMM=intelmpi
export ESMF_BOPT='O'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
ssh fe3 /mnt/lfs4/HFIP/hfv3gfs/Mark.Potts//mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/intel_2020.2_intelmpi_O_develop/getres-int.sh
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
chmod +x runpython.sh
cd nuopc-app-prototypes
./testProtos.sh 2>&1| tee ../nuopc_$JOBID.log 

ssh fe3 /mnt/lfs4/HFIP/hfv3gfs/Mark.Potts//mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/intel_2020.2_intelmpi_O_develop/getres-int.sh
