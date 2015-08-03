#!/bin/bash
webpagename=http://www.cv-foundation.org/openaccess/CVPR2015.py
page_cont=cvpr_cont.html
if [[ ! -f "${page_cont}" ]]; then
curl ${webpagename} -o ${page_cont}
fi
text_only=page_cont_cvpr.txt
sed -e 's/<[^>]*>//g' ${page_cont} > ${text_only}
names_only=cvpr_names_only.txt
egrep "author = {" ${text_only} > ${names_only}
sed -e 's/author = {//g'  ${names_only} > temp.txt
sed -e 's/}//g' temp.txt > ${names_only}
rm temp.txt

tents_fname=tents_cvpr.txt
uniq_fname=cvpr_unique.txt
rm ${uniq_fname}
rm ${tents_fname}

OIFS=$IFS
IFS=
pat=
while read -r line
do
    pat=${line}'|'${pat}
done < slavic_postfixes.txt
IFS=$OIFS
pat=${pat::-1} #remove last |
echo $pat
egrep "$pat" ${names_only} | egrep -v ":|!|{|}|/|Taliesin|;" >> ${tents_fname} #Kill spec symbols and hall name
cat ${tents_fname} | sort -u > ${uniq_fname}; 
cat ${uniq_fname}