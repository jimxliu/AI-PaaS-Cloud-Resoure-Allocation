cd /home/USERNAME/pipeline/

####
#Change the usernames to yours in the following files:
#rc.txt
#sites.xml
####

# generate the dax file
# params:
# pipeline.dax, the to-be generated dax file name
# `pwd` the current directory, should be equal to /home/USERNAME/pipeline/

./generate_dax.sh pipeline.dax `pwd`

# run the workflow
# params:
# pipleine.dax, the abstracted workflow dax file.
./plan_dax.sh pipeline.dax


# output will be in the output/





