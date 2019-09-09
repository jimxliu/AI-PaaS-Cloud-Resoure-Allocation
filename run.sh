#!/bin/bash

DIR=$(cd $(dirname $0) && pwd)

# Create the personal htcondor environment
echo "source..."
source ~/condor-8.8.2/condor.sh

# Read the parameters from command line
echo "read parameters..."
if [ $# -ne 2 ]
then
    echo "Usage: $0 SITES INSTANCES"
    exit 1
fi

# Select the Pegasus Sites (sites.xml) according to the $SITES input
# aws -> ec2_pool
# local -> condorpool
# aws|local -> ec2_pool,condorpool
SITES=""
if [ $1 == 'aws' ]
then
    SITES='ec2_pool'
elif [ $1 == 'local' ]
then
    SITES='condorpool'
elif [ $1 == 'aws|local' ]
then
    SITES='ec2_pool,condorpool'
else
    echo 'parameter SITES is incorrect.'
    exit 2
fi


# If ec2_pool is selected, get the number of EC2 instances
INSTANCES=$2
IFS=',' read -r -a array <<< "$INSTANCES"

# Allocate the ec2 resources
echo "allocate resources..."
for index in "${!array[@]}"
do
    element=${array[index]}
    IFS=':' read -r -a kv <<< "$element"
    echo "type:${kv[0]}, count:${kv[1]}"
    instance=${kv[0]}
    count=${kv[1]}
    if [ $instance != 'local' ]
    then
        yes | condor_annex -count $count -annex-name "Annex$index" -aws-on-demand-instance-type $instance 
    fi
done

# If SITES contains ec2, wait for 3m for ec2 initialization and provisioning
if [ $SITES != 'condorpool' ]
then
    echo "sleep..."
    sleep 3m
fi

# Go to workflow folder
cd ~/pipeline_mix/

# Clean up previous workflow files
echo "remove previous workflows..."
#pegasus-remove submit/xl6v8/pegasus/pipeline/run*
rm -rf submit/xl6v8/pegasus/pipeline/run*

# Run the workflow (.dax file)
echo "run workflow..."
./plan_dax.sh pipeline.dax $SITES 

echo "Done"
