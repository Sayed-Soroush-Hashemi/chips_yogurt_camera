#!/bin/bash

tmp='.tmp/'

while read -r line ; do
	list=($line)
	
	n=0
	for x in ${list[@]} ; do
		let 'n++'
	done
	let 'n--'
	let 'm=n-1'
	
	output_path=${list[$n]}
	output_name=`basename "$output_path"`
	concat_list_name="${output_name}_concat_list.txt"
	concat_list_path="${tmp}/${concat_list_name}"

	mkdir "${tmp}"
	for i in `seq 0 $m` ; do
		cur_out_name="part_${i}_$output_name" 
		cur_out_path="${tmp}/$cur_out_name"
		ffmpeg -i "${list[$i]}" -strict -2 -c:v libx264 "$cur_out_path" < /dev/null
		echo "file '$cur_out_name' " >> "$concat_list_path"
	done
	cd "${tmp}"
	ffmpeg -f concat -i "$concat_list_name" -c copy "$output_name" < /dev/null
	cd ..
	mv "${tmp}/$output_name" "$output_path"
	rm -rf "${tmp}"

done < "${1}"
