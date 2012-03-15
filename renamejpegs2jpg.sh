
#!/bin/sh
for i in `ls $1 | grep -i "\.jpeg"`  ;
do
newname=`echo $i | sed "s/jpeg/jpg/"`
mv ${1}/${i} ${1}/${newname}
done


