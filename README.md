# Automated Workflow Execution with Dynamically Allocated Cloud/Local Resources

**Spring 2019 Cloud Computing Class Project**

## Introduction
Workflow Management System: [Pegasus][pegasus]

Job Scheduler (Cloud): [HTCondor Annex][htcondor_annex]

We integrated the automated workflow management system **Pegasus** with high-throughput distributed computing job scheduling system **HTCondor** to create a AI-optimized Platform-as-a-Service for users to run their workflows reducing the need to manually compare and select the allocation of cloud and/or local computing resources.

## Tutorial

### Setup

Assume your home directory is `/home/USERNAME` on your local machine.

Clone this repo to your home directory

Change the **USERNAME** and **REPONAME**to yours in the following files: `rc.txt` and `sites.xml`.

In our project, we used a simple pipeline of greyscaling an image [code](./pipeline_mix/code/).
Or, supply your own `daxgen.py` to generate the dax file of your own worfklow ([how to write dax file?][dax_file])

### Resource Requirement and Optimization (To do)
We feed the AI optimizer the general resource limitations in the platforms available to the users (AWS EC2, local), and it outputs the optimized platform(s), type and number of instances. We used these results to dynamically allocate resources.

**Platforms**: AWS EC2 (aws), Local Condor Pool (local)

### Allocate Resources and Execute Workflow

Run `run.sh`:

```
$ run.sh PLATFORMS [INSTANCES]
```

, where PLATFORMS can be: `aws`, `local`, or `aws|local`, INSTANCES is a comman-delimited string: instance-type2:count,instance-type2:count2.

For example: `$ run.sh aws t2.micro:2,t2.nano:3` 

Above example shows that the workflow will only be executed remotely on AWS EC2, on 2 instances of t2.micro and 3 instances of t2.nano.

### Output
Check [output](./pipeline_mix/output/) for greyscalled image.

### Performance Monitoring

Run `./metrics/metrics.sh` [code](./metrics/metrics.sh)


## Project Report

[Here](./project_report.pdf) is a comprehensive report about this project.

[pegasus]: https://pegasus.isi.edu/documentation/tutorial.php#tutorial_introduction
[htcondor_annex]: https://research.cs.wisc.edu/htcondor/manual/v8.7.10/HTCondorAnnexUsersGuide.html
[dax_file]: https://pegasus.isi.edu/documentation/python/

