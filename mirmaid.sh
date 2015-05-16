#!/bin/bash
CONFROOT=/etc/mirmaid/mirrors.d
for root in `ls ${CONFROOT}`
do
  while read LINE
  do
    DIRECTORY=`echo ${LINE} | cut -d' ' -f1`
    URL=`echo ${LINE} | cut -d' ' -f2`
    OPT=`echo ${LINE} | cut -d' ' -f3`
    OPT=${OPT} `echo ${LINE} | cut -d' ' -f4`
    OPT=`echo ${OPT} | sed 's/flat/-nH --cut-dirs=100/g'`
    if [ ! -d "${DIRECTORY}" ]
    then
      mkdir -p "${DIRECTORY}"
    fi
    if [ "${OPT}" == "" ]
    then
      wget -r -N --no-parent -nH -P ${DIRECTORY} ${URL} &
    else
      wget -r -N --${OPT} --no-parent -nH --cut-dirs=100 -P ${DIRECTORY} ${URL} &
    fi
  done < "${CONFROOT}/${root}"
  wait
done