Sat Sep 25 04:01:55 GMT 2021
#!/bin/sh -l
#SBATCH --account=hfv3gfs
#SBATCH -o test-gfortran_9.2.0_openmpi_g.bat_%j.o
#SBATCH -e test-gfortran_9.2.0_openmpi_g.bat_%j.e
#SBATCH --time=2:00:00
#SBATCH --partition=xjet
#SBATCH --qos=batch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --exclusive
export JOBID=$SLURM_JOBID
export ESMF_NETCDF_LIBS="-lnetcdff -lnetcdf -lhdf5_hl -lhdf5"
module load gnu/9.2.0 openmpi/3.1.4 netcdf/4.7.2
module load hdf5/1.10.5 
module list >& module-test.log

set -x
export ESMF_NETCDF=nc-config

export ESMF_DIR=/mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/gfortran_9.2.0_openmpi_g_develop
export ESMF_COMPILER=gfortran
export ESMF_COMM=openmpi
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
ssh fe3 /mnt/lfs4/HFIP/hfv3gfs/Mark.Potts//mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/gfortran_9.2.0_openmpi_g_develop/getres-int.sh
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
chmod +x runpython.sh
cd nuopc-app-prototypes
./testProtos.sh 2>&1| tee ../nuopc_$JOBID.log 

ssh fe3 /mnt/lfs4/HFIP/hfv3gfs/Mark.Potts//mnt/lfs4/HFIP/hfv3gfs/Mark.Potts/gfortran_9.2.0_openmpi_g_develop/getres-int.sh
