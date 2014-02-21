#!/bin/sh

E_BADARGS=65
EXPECTED_ARGS=2

usage() {
    echo "Usage: $0 diffdir2 diffdir3"
    echo "  current directory is diffdir1"
    echo " - diffs current directory against diffdir2"
    echo " - all equal files will be diff'ed against diffdir3"
    echo " -- so you know which files eqal in 2 directories differs against a third"
    exit $E_BADARGS 
}

if [ $# -ne $EXPECTED_ARGS ]
then
  usage
fi

for foundfile in $(find . -type f -name "*");
do
  foundfile2=$1$foundfile
  foundfile3=$2$foundfile

  if [ ! -f "$foundfile2" ]; then
    continue;
  fi
  if [ ! -f "$foundfile3" ]; then
    continue;
  fi
  diff $foundfile $foundfile2 > /dev/null
  if [[ "$?" == "1" ]]; then
    ((diff12++)) 
  else  
    diff $foundfile2 $foundfile3 > /dev/null
    if [[ "$?" == "1" ]]; then 
      echo "found replace-file $foundfile3"
    fi
  fi
  diff $foundfile $foundfile3 > /dev/null
  if [[ "$?" == "1" ]]; then
    ((diff13++)) 
  fi  
  diff $foundfile2 $foundfile3 > /dev/null
  if [[ "$?" == "1" ]]; then
    ((diff23++))
  fi
done

echo . to $1 differs in $diff12 files
echo . to $2 differs in $diff13 files
echo $1 to $2 differs in $diff23 files
