#!/bin/bash

set -x
:<<!
#check parameter
if [ $# -lt 2 ]
then
    echo "usage: $0 <header file> <key value file> <tail file>"
    return 
fi
!

# get file name
languageArray=("en" "jp" "cn" "cs" "da" "de" "it" "nt" "np" "dd")

languageString=`sed -n '1p' $1`

cols=`sed -n '2p' $1 | awk -F "\t" '{print NF}'`

for i in `seq 0 ${cols}`
do
    languageArray[i]=`echo ${languageString} | awk -F "\t" '{print $'$i'}' `
done

echo ${languageArray[@]}
:<<!
for elem in ${languageArray[@]}
do
    echo $elem
done
!
:<<!
for i in `seq 2 ${cols}`
    do
    #    eval j=`$i-2` 
    j=`expr $i-2` 
    echo ${languageArray[$j]}
    fileName=${languageArray[$j]}.xml
    cat $2 > ${fileName} 
    echo >> ${fileName} 
    cat $1 | awk -F "\t" 'BEGIN {}; { print "\t<data name=\""$1"\" xml:space=\"preserve\">\n\t\t<value>" $'${i}' "</value>\n\t</data>"}; END {print "</root>"}' >> ${fileName} 
    
done
!

set +x
