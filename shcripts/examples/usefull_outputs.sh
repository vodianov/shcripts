while read line
do
  echo $line
done < input.txt

while IFS= read -r line; do
    #TODO: //something
done < "$input_file"
