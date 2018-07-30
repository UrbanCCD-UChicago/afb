#!/usr/bin/env bash

# set -ex

echo ""
echo ""
echo "################################"
echo "#        Biweekly Slice        #"
echo "# $(date) #"
echo "################################"

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

echo "dataset=$dataset"
echo "slug=$slug"
echo "workdir=$workdir"
echo "slice_tool=$slice_tool"
echo "afb_host=$afb_host"
echo "pwd=$pwd"

cd $workdir

echo "downloading the big tarball from the mcs server"
wget --quiet http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/$dataset.latest.tar

echo "getting the name of the directory in the tarball"
ext_lines=`tar -tf $dataset.latest.tar`
readarray -t ext_arr <<< "$ext_lines"
extraction="${ext_arr[0]}"
echo "extraction=$extraction"

echo "decompressing the tarball"
tar xf $dataset.latest.tar

echo "setting start and end dates to build slice"
starts=`date --date="14 days ago" +"%Y-%m-%d"`
ends=`date +"%Y-%m-%d"`
echo "starts=$starts"
echo "ends=$ends"

echo "slicing the gzipped data.csv"
python3 $slice_tool "$workdir/$extraction" $starts $ends

echo "renaming the output of the slice"
dirname="${extraction::-1}.from-$starts-to-$ends"
renamed="$slug.1-week.csv.gz"
echo "rename=$renamed"
mv $dirname/data.csv.gz $renamed

echo "uploading the sliced data to s3"
aws s3 cp $renamed s3://aot-tarballs/ --quiet

echo "cleaning up"
rm -rf $dataset*
rm -rf $extraction*
rm -rf $dirname*
rm -rf $renamed*
rm -rf $slug*

cd $pwd
