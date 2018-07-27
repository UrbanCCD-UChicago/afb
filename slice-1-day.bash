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
    --afb-hostname)
      afb_host=$2
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

# decompress the tarball
tar xf $dataset.latest.tar

# set yesterday to build slice
yesterday=`date --date="1 day ago" +"%Y-%m-%d"`

# slice the gzipped data.csv
python3 $slice_tool "$workdir/$extraction" $yesterday $yesterday

# rename the output of the slice
dirname="${extraction::-1}.from-$yesterday-to-$yesterday"
renamed="$slug.1-day.csv.gz"
mv $dirname/data.csv.gz $renamed

# upload the sliced data to s3
aws s3 cp $renamed s3://aot-tarballs/

# tar up the metadata
mkdir $slug
mv $extraction/nodes.csv $slug/
mv $extraction/sensors.csv $slug/
mv $extraction/provenance.csv $slug/
mv $extraction/README.md $slug/
tar cf $slug.metadata.tar $slug

# upload metadata to s3
aws s3 cp $slug.metadata.tar s3://aot-tarballs/

# notify AFB of new metadata
curl "http://$afb_host/data-sets/$slug/process"

# clean up
rm -rf $dataset*
rm -rf $extraction*
rm -rf $dirname*
rm -rf $renamed*
rm -rf $slug*

# go back to where you started
cd $pwd
