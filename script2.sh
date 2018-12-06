
tar xzf $1
a="$1"
b=${a%.tar.gz*}

touch final

find . -type f -name "*.txt" | while read txt; do
 	cat "$txt" | grep -m 1 '^https' >> final
done

 if [ ! -d "assignments" ];
 then
 	mkdir assignments
 fi

touch repoz
counter=0
while read line
do
     cd assignments
     counter=$((counter+1))
     git clone "$line" "repo$counter" > /dev/null 2> /dev/null
     k="$?"
     if [ "$k" == "0" ];
     then 
	echo "$line"" : Cloned"
	echo "repo$counter" >> ../repoz 
     else 
	echo "$line"" : Cloning FAILED"
     fi

     cd ..

done < final


while read line
do
     cd "assignments/$line"
	dirs=$(find "`pwd`" -mindepth 1 -type d | grep -v './\.'| wc -l )
	txtfiles=$(find "`pwd`" -mindepth 1 -type f -name '*.txt'  | grep -v './\.'| wc -l )
	othersfiles=$(find "`pwd`" -mindepth 1 -type f ! -name '*.txt' | grep -v './\.'| wc -l )
	echo "$line"":" 
     	echo "Number of directories :""$dirs"
	echo "Number of txt files :""$txtfiles"
	echo "Number of other files :" "$othersfiles"
     	first_dir=$(find "`pwd`" -mindepth 1 -maxdepth 1 -type d -name "more" | grep -v './\.'| wc -l )
	dataA_txt=$(find "`pwd`" -mindepth 1 -maxdepth 1 -type f -name 'dataA.txt'  | grep -v './\.'| wc -l )
	dataB_txt=$(find "`pwd`" -mindepth 2 -maxdepth 2 -type f -name 'dataB.txt'  | grep -v './\.'| wc -l )
	dataC_txt=$(find "`pwd`" -mindepth 2 -maxdepth 2 -type f -name 'dataC.txt'  | grep -v './\.'| wc -l )
	if [ "$othersfiles" == "0" -a "$txtfiles" == "3" -a  "$dirs" == "1" ];
	then 
		if [ "$dataA_txt" == "1" -a "$dataB_txt" == "1" -a  "$dataC_txt" == "1" -a "$first_dir" == "1" ];
		then
		 	echo "Directory structure is OK"
		fi
	else 
		echo "Directory structure is NOT OK"
	fi
	
     cd ..
     cd ..	
done < repoz

rm repoz
rm final
rm -rf "$b"








