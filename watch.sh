#!/bin/bash
# add berow to crontab
# * * * * * for i in `seq 0 5 59`;do (sleep ${i}; /bin/bash -lc 'cd /home/amano/haaabot && ./watch.sh') & done;
if [ ! -e ruboty.pid ] && [ `ps -ef | grep ruboty | grep -v grep | wc -l` = 0 ]; then
  './start.sh'
fi
