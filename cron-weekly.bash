#!/usr/bin/env bash

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Syracuse.complete \
  --slug syracuse-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Denver.complete \
  --slug denver-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Stanford.complete \
  --slug stanford-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_UNC.complete \
  --slug unc-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Detroit.complete \
  --slug detroit-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Portland.complete \
  --slug portland-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_UW.complete \
  --slug uw-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Seattle.complete \
  --slug seattle-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_NIU.complete \
  --slug niu-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Chicago.public \
  --slug chicago-public \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py

/usr/bin/env bash /home/vforgione/slice-weekly.bash \
  --dataset AoT_Chicago.complete \
  --slug chicago-complete \
  --workdir /storage/afb \
  --slice-tool-path /home/vforgione/slice-date-range.py
