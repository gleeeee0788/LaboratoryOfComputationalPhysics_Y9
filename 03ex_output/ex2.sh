#!/bin/bash

#2a Make a copy of the file `data.csv` removing the metadata and the commas between numbers; call it `data.txt`
grep -v "^#" data.csv | sed 's/,//g' > data.txt
echo "✅ 2a. Text file created"


#2b How many even numbers are there?
counter=0
while IFS= read -r line
do
    for number in $line
    do
        if [ $(($number % 2)) -eq 0 ]; then
            counter=$((counter + 1))
            # ((counter++))
        fi
    done
done < "data.txt"
echo "✅ 2b. There are $counter even numbers"


#2c Distinguish the entries on the basis of `sqrt(X^2 + Y^2 + Z^2)` is greater or smaller than `100*sqrt(3)/2`. 
#Count the entries of each of the two groups 
group1=0
group2=0
group3=0
tol=$(echo "100*sqrt(3)/2" | bc -l)
while IFS=' ' read -r X Y Z rest
do
    result=$(echo "sqrt($X^2 + $Y^2 + $Z^2)" | bc -l)
    if (( $(echo "$result > $tol" | bc -l) )); then
        ((group1++))
    elif (( $(echo "$result < $tol" | bc -l) )); then
        ((group2++))
    else
        ((group3++))
    fi
done < "data.txt"
echo -e "✅ 2c. $group1 numbers are greater than $tol\n\t$group2 numbers are less than $tol\n\t$group3 numbers are equal to $tol"


#2d Make `n` copies of data.txt (with `n` an input parameter of the script), 
#where the i-th copy has all the numbers divided by i (with `1<=i<=n`).
DIR="data_copies"
mkdir -p "$DIR"
read -p "Enter number of copies: " n_copies

for (( i=1; 1<=n_copies; i++ ))
do
    awk '{for (j=1; j<=NF; j++) $j=$j/$i; print}' data.txt > "$DIR/copy_$i.csv"
done