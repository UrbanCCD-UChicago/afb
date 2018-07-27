#!/usr/bin/env bash

# set -ex

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --data-set)
      dataset=$2
      shift
      shift
    ;;
    --afb-slug)
      slug=$2
      shift
      shift
    ;;
    --work-dir)
      workdir=$2
      shift
      shift
    ;;
    --slice-tool-path)
      slice_tool=$2
      shift
      shift
    ;;
    *)
      POSITIONAL+=("$1")
      shift
    ;;
  esac
done
set -- "${POSITIONAL[@]}"

pwd=`pwd`

cd $workdir

# download the big tarball from the mcs server
wget http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/$dataset.latest.tar

# get the name of the directory in the tarball
ext_lines=`tar -tf $dataset.latest.tar`
readarray -t ext_arr <<< "$ext_lines"
extraction="${ext_arr[0]}"

# decompress tarball
tar xf $dataset.latest.tar

# set slicing start and end dates
starts=`date --date="1 month ago" +"%Y-%m-%d"`
ends=`date +"%Y-%m-%d"`

# slice the gzipped data.csv
python3 $slice_tool "$workdir/$extraction" $starts $ends

# rename the output of the slice
dirname="${extraction::-1}.from-$starts-to-$ends"
renamed="$slug.1-month.csv.gz"
mv $dirname/data.csv.gz $renamed

# upload the sliced data to s3
aws s3 cp $renamed s3://aot-tarballs/

# clean up
rm -rf $dataset.latest.tar
rm -rf $extraction
rm -rf $dirname
rm -rf $renamed

# go back to where you started
cd $pwd
