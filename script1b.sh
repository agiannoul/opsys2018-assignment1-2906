#!/bin/bash

myfunction() {
    
    name=$( echo "$line" | tr "/" "_"  )
    if [ ! -f "$name" ];
    then
	  b=$( wget -qO- $line  )
	  failed=$?
	  touch "$name"
	  echo "$b" > "$name"
	  if [ "$failed" == "0" ]
	  then 
	  	echo "$line"" INIT"
     	  else 
		echo "" > "$name"
	  	>&2 echo "$line"" FAILED INIT"
 	  fi
    else
   
    	a=$( cat "$name" )
    	temp=$( wget -qO- $line  )
	k=$?
	if [ ! "$k" == "0" ] && [ ! "$a" == "" ]
	then
      		>&2 echo "$line"" FAILED"
		echo "" > "$name"

    	else 
		if [ ! "$a" == "$temp" ]
    		then
       			echo "$line"
			echo "$temp" > "$name"
	        fi
	fi
    fi
}



file="$1"
cat "$file" | grep '^[^#]' > "RealSites"
file="RealSites"

while IFS= read line
do
    myfunction &
    wait
done < "$file"

rm "RealSites"