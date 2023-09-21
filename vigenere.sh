#!/bin/bash

	e=
	p=
	d=
	c=
	k=

	while getopts ":epdc:k:" opt; do
	   case $opt in
	     e) e=1;;
	     p) p=1;;
	     d) d=1;;
	     c) c=$OPTARG;;
	     k) k=$OPTARG;;
	     \?) echo "Invalid option: -$OPTARG" >&2
		 exit 1;;
	     :)  echo "Option -$OPTARG requires an argument." >&2
		 exit 1;;
	   esac
	done

  
declare -A matrix
	matrix=(["A"]="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	["B"]="BCDEFGHIJKLMNOPQRSTUVWXYZA" ["C"]="CDEFGHIJKLMNOPQRSTUVWXYZAB"
	["D"]="DEFGHIJKLMNOPQRSTUVWXYZABC" ["E"]="EFGHIJKLMNOPQRSTUVWXYZABCD"
	["F"]="FGHIJKLMNOPQRSTUVWXYZABCDE" ["G"]="GHIJKLMNOPQRSTUVWXYZABCDEF"
	["H"]="HIJKLMNOPQRSTUVWXYZABCDEFG" ["I"]="IJKLMNOPQRSTUVWXYZABCDEFGH"
	["J"]="JKLMNOPQRSTUVWXYZABCDEFGHI" ["K"]="KLMNOPQRSTUVWXYZABCDEFGHIJ"
	["L"]="LMNOPQRSTUVWXYZABCDEFGHIJK" ["M"]="MNOPQRSTUVWXYZABCDEFGHIJKL"
	["N"]="NOPQRSTUVWXYZABCDEFGHIJKLM" ["O"]="OPQRSTUVWXYZABCDEFGHIJKLMN"
	["P"]="PQRSTUVWXYZABCDEFGHIJKLMNO" ["Q"]="QRSTUVWXYZABCDEFGHIJKLMNOP"
	["R"]="RSTUVWXYZABCDEFGHIJKLMNOPQ" ["S"]="STUVWXYZABCDEFGHIJKLMNOPQR"
	["T"]="TUVWXYZABCDEFGHIJKLMNOPQRS" ["U"]="UVWXYZABCDEFGHIJKLMNOPQRST"
	["V"]="VWXYZABCDEFGHIJKLMNOPQRSTU" ["W"]="WXYZABCDEFGHIJKLMNOPQRSTUV"
	["X"]="XYZABCDEFGHIJKLMNOPQRSTUVW" ["Y"]="YZABCDEFGHIJKLMNOPQRSTUVWX"
	["Z"]="ZABCDEFGHIJKLMNOPQRSTUVWXY")

declare -A letter_to_num
	letter_to_num=(["A"]=1 ["B"]=2 ["C"]=3 ["D"]=4 ["E"]=5 ["F"]=6 ["G"]=7
	["H"]=8 ["I"]=9 ["J"]=10 ["K"]=11 ["L"]=12 ["M"]=13 ["N"]=14 ["O"]=15
	["P"]=16 ["Q"]=17 ["R"]=18 ["S"]=19 ["T"]=20 ["U"]=21 ["V"]=22 ["W"]=23
	["X"]=24 ["Y"]=25 ["Z"]=26)


text="$3"
key="$5"

encrypt() {

	while [ ${#key} -lt ${#text} ]; do
		key=${key}${key}
	done
	key=${key:0:${#text}}

	encrypted=""

	for (( i=0; i<${#text}; i++ )); do
		row=${text:$i:1}
		col=${key:$i:1}

		row_num=${letter_to_num[$row]}
		col_num=${letter_to_num[$col]}

		row_num=$((row_num - 1))
		col_num=$((col_num - 1))

		row_element=${matrix[$row]}
		encrypted_letter=${row_element:$col_num:1}
		encrypted+=$encrypted_letter
	done

	echo "Encrypted text: $encrypted"
}

decrypt() {
	while [ ${#key} -lt ${#text} ]; do
		key=${key}${key}
	done
	key=${key:0:${#text}}

	decrypted=""
	 
	 
	for ((i=0; i<${#text}; i++)); do
		char=${text:i:1}

		key_char=${key:i:1}

		element=${matrix[$key_char]}

		char_num=-1
		for ((j=0; j<${#element}; j++)); do
			if [ "${element:j:1}" == "$char" ]; then
				char_num=$j
				break
			fi
		done
		temp_num=$(($char_num))
		decrypted_char=${matrix["A"]:temp_num:1}
		decrypted+=$decrypted_char
	done
	echo "Decrypted text: $decrypted"
}


	if [[ $e -eq 1 && $p -eq 1 ]]; then
		encrypt
	elif [[ $d -eq 1 ]]; then
		decrypt
	else
		echo "Error: Invalid combination of arguments. You must specify either -e -p TEXT -k KEY (encrypt) or -d -c TEXT -k KEY (decrypt)." >&2
		exit 1
	fi
