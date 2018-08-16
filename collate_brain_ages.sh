#!/bin/bash
## brainageR script for collating brain predicted age results within a single directory
## James Cole, King's College London james.cole@kcl.ac.uk
## software version 1.0 09 Aug 2018
directory=$1
output_name=$2

if [ "$#" -ne 2 ]; then
    echo "You must specify two arguments, collate_brain_ages.sh <directory> <output.csv>"
    exit 1
fi

header=`echo File,brain.predicted_age`
for i in `find $directory -type f -name \*csv | sort | xargs -I x grep -l brain.predicted_age x`; do
	j=`wc -l $i | awk '{print $1}'`
	if [ $j == 2 ]; then
		tail -n +2 $i >> tmp.data.file
	fi
done

echo $header > tmp.header.file
cat tmp.header.file tmp.data.file > $output_name
rm tmp.*.file
