#!/bin/bash
THESIS="thesis.lyx"
function copypreamble(){
	f=0
	OLDIFS="$IFS"
	IFS=
	while read -r line
	do
	 case $line in 
	  *begin_preamble*) f=1; continue ;;
	  *end_preamble*) f=0; return
	 esac
	 if [ "$f" -eq 1 ]; then
		echo "$line"
	 fi
	done < <(cat $1)
	IFS="$OLDIFS"
}

function replace(){
	haspreamble=$(grep begin_preamble $1)
	if [ -z $haspreamble ]; then
		OLDIFS="$IFS"
		IFS=
		while read -r line
		do	 
		 case $line in 
		  *textclass*) 			
			echo "$line"; 
			echo "\begin_preamble"
			echo "$2"
			echo "\end_preamble"
			continue ;;
		  *)
			echo "$line"
		  ;;
		 esac		
		done < <(cat $1)
		IFS="$OLDIFS"
		return
	fi
	f=0
	OLDIFS="$IFS"
	IFS=
	while read -r line
	do	 
	 case $line in 
	  *begin_preamble*) f=1; echo "$line"; continue ;;
	  *end_preamble*) f=0;
	 esac
	 if [ "$f" -eq 0 ]; then
		echo "$line"
	 elif [ "$f" -eq 1 ]; then
		f=2
		echo "$2"
	 fi
	
	done < <(cat $1)
	IFS="$OLDIFS"
}

preamble=$(echo "$(copypreamble $THESIS)")

for lyxfile in $(find . -name "*.lyx"); do
	if ! [ $(basename $lyxfile) == $THESIS ];then
		newcontent=$(replace $lyxfile "$preamble")
		echo "$newcontent" > $lyxfile
	fi
done



#echo "$newcontent" > introtest.lyx
#sed -i "/begin_preamble/,/end_preamble/{/begin_preamble/n;/end_preamble/!{s|.*|$preamble|g}}" introtest.lyx
#sed -i 's/\begin_preamble.*\end_preamble/\begin_preamble $preamble \end_preamble/g' introtest.lyx
