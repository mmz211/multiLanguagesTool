#!/bin/bash

set -x


#check parameter
:<<!
if [ $# -lt 2 ]
then
    echo "usage: $0 <header file> <key value file> <tail file>"
    exit 2
fi
!

# get file name
languageArray=("en" "jp" "cn" "cs" "da" "de" "it" "nt" "np" "dd")

languageString=`sed -n '1p' $1`

cols=`sed -n '2p' $1 | awk -F "\t" '{print NF}'`

#headertxt=$(cat 1header.txt | xargs echo)

before_key=`cat 2before_key.txt | sed "s/\"/"'\\\"'"/g" | xargs echo`
between_key_value=`cat 3between_key_value.txt | sed "s/\"/"'\\\"'"/g" | xargs echo`
after_value=`cat 4after_value.txt | sed "s/\"/"'\\\"'"/g" | xargs echo`
#before_key=$(cat 2before_key.txt | xargs echo)
#between_key_value=$(cat 3between_key_value.txt | xargs echo)
#after_value=$(cat 4after_value.txt | xargs echo)
#tailtxt=$(cat 5tail.txt | xargs echo)

set +x

:<<!
for i in `seq 0 ${cols}`
do
    languageArray[i]=`echo ${languageString} | awk -F "\t" '{print $'$i'}' `
done

set +x
!

echo ${languageArray[@]}

:<<!
for elem in ${languageArray[@]}
do
    echo $elem
done
!

set -x

for i in `seq 2 ${cols}`
    do
    let j=$i-2
    j=`expr $i - 2` 
    echo $j
#    echo ${languageArray[$j]}
    fileName=${languageArray[$i]}.xml
    cat 1header.txt > ${fileName} 
    echo >> ${fileName} 
    #cat $1 | awk -F "\t" 'BEGIN {}; { print "'$before_key'"$1"'$between_key_value'" $'${i}' "'$after_value'"}; END {print "'$tailtxt'"}' 
    cat $1 | awk -F "\t" 'BEGIN {}; { print "'"${before_key}"'" $1 "'"${between_key_value}"'" $'${i}' "'"${after_value}"'"}; END {}' >> ${fileName}
    echo >> ${fileName} 
    cat 5tail.txt >> ${fileName} 
    
done

