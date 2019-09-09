#!/bin/bash
set -e
pegasus_lite_version_major="4"
pegasus_lite_version_minor="9"
pegasus_lite_version_patch="1"
pegasus_lite_enforce_strict_wp_check="true"
pegasus_lite_version_allow_wp_auto_download="true"

. pegasus-lite-common.sh

pegasus_lite_init

# cleanup in case of failures
trap pegasus_lite_signal_int INT
trap pegasus_lite_signal_term TERM
trap pegasus_lite_unexpected_exit EXIT

echo -e "\n########################[Pegasus Lite] Setting up workdir ########################"  1>&2
# work dir
export pegasus_lite_work_dir=$PWD
pegasus_lite_setup_work_dir

echo -e "\n##############[Pegasus Lite] Figuring out the worker package to use ##############"  1>&2
# figure out the worker package to use
pegasus_lite_worker_package

echo -e "\n##################### Setting the xbit for executables staged #####################"  1>&2
# set the xbit for any executables staged
if [ ! -x dax-pipeline.sh-4_0 ]; then
    /bin/chmod +x dax-pipeline.sh-4_0
fi

echo -e "\n##################### Checking file integrity for input files #####################"  1>&2
# do file integrity checks
pegasus-integrity --print-timings --verify=stdin 1>&2 << 'eof'
rgb2grey.py:image.png
eof

set +e
job_ec=0
echo -e "\n######################[Pegasus Lite] Executing the user task ######################"  1>&2
pegasus-kickstart -n dax::pipeline.sh:4.0 -N ID0000001 -R condorpool  -s output.png=output.png -L pipeline -T 2019-04-30T16:29:29-06:00 ./dax-pipeline.sh-4_0 rgb2grey.py image.png output.png
job_ec=$?
set -e

set -e


# clear the trap, and exit cleanly
trap - EXIT
pegasus_lite_final_exit

