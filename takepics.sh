#!/bin/bash
#clean up in case a process was going on earlier instead of sleeping.
if [ -f screen_-000001.jpg ] ; then
rm screen_-000001.jpg
fi
if [ -f tocomp.txt ] ; then
rm tocomp.txt
fi
if [ -f difference.png ] ; then
rm difference.png
fi

count=`ls | wc -l`
precount=`echo "$count - 1" | bc`
padcount=`printf "%06d" $count`
padprecount=`printf "%06d" $precount`
echo "current count is $count"
while true; do
wnum=`wmctrl -d | grep "*" | sed -r "s/.*Workspace ([0-9]+)/\1/"`
if [ "$wnum" = "2" ] ; then
#We are in the right workspace
wheight=`xrandr | grep "current" | sed -r "s/.*current [0-9]+ x ([0-9]+),.*/\1/"`
newheight=`echo "$wheight - 30" | bc`
import -window root -crop 1600x${newheight}-0+30 -quality 80 screen_${padcount}.jpg
if [ ! -f screen_${padprecount}.png ] ; then
import -window root -crop 1600x${newheight}-0+30 -quality 80 screen_${padprecount}.jpg
fi
compare -dissimilarity-threshold 1 -metric AE screen_${padprecount}.jpg screen_${padcount}.jpg difference.png 2> tocomp.txt
cmp=`cat tocomp.txt`
rm tocomp.txt
#echo "$cmp woo"
rm difference.png
if [ `echo "$cmp > 800" | bc` = "1" ] ; then
precount=$count
count=`echo "$count + 1" | bc`
padcount=`printf "%06d" $count`
padprecount=`printf "%06d" $precount`
fi
#end workspace test.
fi
sleep 1
done
