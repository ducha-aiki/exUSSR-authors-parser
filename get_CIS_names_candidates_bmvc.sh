#!/bin/bash
webpagename=http://bmvc2015.swan.ac.uk/?p=2161
page_cont=bmvc_cont.html
if [[ ! -f "${page_cont}" ]]; then
curl ${webpagename} -o ${page_cont}
fi
text_only=page_cont_bmvc.txt
tents_fname=tents_bmvc.txt
uniq_fname=bmvc_unique.txt
rm ${uniq_fname}
rm ${tents_fname}
sed -e 's/<[^>]*>//g' ${page_cont} > ${text_only}
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
egrep "$pat" ${text_only} | egrep  ", | and " | egrep -v ":|!|{|}|/|Taliesin|;" >> ${tents_fname} #Kill spec symbols and hall name
cat ${tents_fname} | sort -u > ${uniq_fname}; 
cat ${uniq_fname}