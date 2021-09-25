Sat Sep 25 02:58:46 EDT 2021
#!/bin/sh -l
#SBATCH --account=s2326
#SBATCH -o test-pgi_2020_mpiuni_g.bat_%j.o
#SBATCH -e test-pgi_2020_mpiuni_g.bat_%j.e
#SBATCH --time=1:20:00
#SBATCH --partition=compute
#SBATCH --qos=allnccs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --exclusive
export JOBID=$SLURM_JOBID
module load comp/pgi/20.4  

module list >& module-test.log

set -x

export ESMF_DIR=/gpfsm/dnb04/projects/p98/mpotts/esmf/pgi_2020_mpiuni_g_develop
export ESMF_COMPILER=pgi
export ESMF_COMM=mpiuni
export ESMF_BOPT='g'
export ESMF_TESTEXHAUSTIVE='ON'
export ESMF_TESTWITHTHREADS='ON'
make info 2>&1| tee info.log 
make install 2>&1| tee install_$JOBID.log 
make all_tests 2>&1| tee test_$JOBID.log 
ssh discover23 /gpfsm/dnb04/projects/p98/mpotts/esmf//gpfsm/dnb04/projects/p98/mpotts/esmf/pgi_2020_mpiuni_g_develop/getres-int.sh
export ESMFMKFILE=`find $PWD/DEFAULTINSTALLDIR -iname esmf.mk`
chmod +x runpython.sh
cd nuopc-app-prototypes
./testProtos.sh 2>&1| tee ../nuopc_$JOBID.log 

ssh discover23 /gpfsm/dnb04/projects/p98/mpotts/esmf//gpfsm/dnb04/projects/p98/mpotts/esmf/pgi_2020_mpiuni_g_develop/getres-int.sh
