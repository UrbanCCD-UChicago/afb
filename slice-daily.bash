#!/bin/bash

# set -ex

echo ""
echo ""
echo "################################"
echo "#         Daily Slice          #"
echo "# $(date) #"
echo "################################"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --dataset)
      dataset=$2
      shift
      shift
    ;;
    --slug)
      slug=$2
      shift
      shift
    ;;
    --workdir)
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
      afb_hostname=$2
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

echo "  dataset=$dataset"
echo "  slug=$slug"
echo "  workdir=$workdir"
echo "  slice_tool=$slice_tool"
echo "  afb_hostname=$afb_hostname"

pwd=`pwd`
cd $workdir

echo "downloading tarball from mcs"
wget --quiet http://www.mcs.anl.gov/research/projects/waggle/downloads/datasets/$dataset.latest.tar

tarball=$dataset.latest.tar

echo "getting extraction dirname"
ext_lines=`tar tf $tarball`
readarray -t ext_arr <<< "$ext_lines"
extraction_dirname="$workdir/${ext_arr[0]}"
echo "  extraction_dirname=$extraction_dirname"

echo "decompressing tarball"
tar xf $tarball
rm $tarball

echo "setting dates to build the slice"
yesterday=`date --date="1 day ago" +"%Y-%m-%d"`
echo "  yesterday=$yesterday"

echo "slicing data.csv.gz"
python3 $slice_tool $extraction_dirname $yesterday $yesterday
rm -r $extraction_dirname

echo "renaming the slice output directory"
sliced_dirname="${extraction_dirname::-1}.from-$yesterday-to-$yesterday"
echo "  sliced_dirname=$sliced_dirname"
renamed="$slug.daily.$yesterday"
echo "  renamed=$renamed"
mv $sliced_dirname $renamed

echo "tarring up the sliced directory"
tarball=$renamed.tar
echo "  tarball=$tarball"
tar cf $tarball $renamed
rm -r $renamed

echo "uploading the slice tarball to s3"
/home/vforgione/.local/bin/aws s3 cp $tarball s3://aot-tarballs/ --quiet
/home/vforgione/.local/bin/aws s3api put-object-tagging --bucket aot-tarballs --key $tarball --tagging "TagSet=[{Key=slice,Value=daily}]"
rm $tarball

echo "notifying afb to update metadata"
curl --silent https://$afb_hostname/data-sets/$slug/process?archive=$tarball

cd $pwd

echo "done!"
