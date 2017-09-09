#!/bin/bash

dir1=$1
dir2=$2

# show files that are different only
cmd="diff -rq $dir1 $dir2"
eval $cmd
filenames_str=`$cmd`

# remove lines that represent only one file, keep lines that have
# files in both dirs, but are just different
tmp1=`echo "$filenames_str" | sed -n '/ differ$/p'` 

# grab just the first filename for the lines of output
tmp2=`echo "$tmp1" | awk '{ print $2 }'`

# convert newlines sep to space
fs=$(echo "$tmp2") 

# convert string to array
fa=($fs) 

for file in "${fa[@]}"
do
    # drop first directory in path to get relative filename
    rel=`echo $file | sed "s#${dir1}/##"`

    # determine the type of file
    file_type=`file -i $file | awk '{print $2}' | awk -F"/" '{print $1}'`

    # if it's a text file send it to meld
    if [ $file_type == "text" ]
    then
        meld $dir1/$rel $dir2/$rel &> /dev/null
    fi 
done

