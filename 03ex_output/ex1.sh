#!/bin/bash

#1a Make a new directory called `students` in your home. 
#Download a csv file with the list of students of this lab from [here](https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv) 
#(use the `wget` command) and copy that to `students`. 
#First check whether the file is already there
DIR="$HOME/students"
mkdir -p "$DIR"

if [ ! -f "$DIR/students.csv" ]; then
    wget -O "$DIR/students.csv" "https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv?dl=1"
    echo "✅ 1a. File downloaded"
else
    echo "✅ 1a. The file exists"
fi


#1b Make two new files, one containing the students belonging to PoD, the other to Physics.
head -n 1 "$DIR/students.csv" > "$DIR/PoD.csv"
grep ",PoD" "$DIR/students.csv" >> "$DIR/PoD.csv"

head -n 1 "$DIR/students.csv" > "$DIR/Physics.csv"
grep ",Physics" "$DIR/students.csv" >> "$DIR/Physics.csv"
echo "✅ 1b. Files created successfully"


#1c For each letter of the alphabet, count the number of students whose surname starts with that letter. 
for letter in {A..Z}
do
    count=$(tail -n +2 "$DIR/students.csv" | grep -ci "^$letter")
    echo "$letter: $count students"
done
echo "✅ 1c. Count done"


#1d Find out which is the letter with most counts.
max_count=0
max_letter=""
for letter in {A..Z}
do
    count=$(tail -n +2 "$DIR/students.csv" | grep -ci "^$letter")
    if [ "$count" -gt "$max_count" ]; then
        max_count=$count
        max_letter=$letter
    fi
done
echo "✅ 1d. The letter with the most students is $max_letter ($max_count students)"


#1e Assume an obvious numbering of the students in the file (first line is 1, second line is 2, etc.), 
#group students "modulo 18", i.e. 1,19,37,.. 2,20,38,.. etc. and put each group in a separate file
for i in {1..18}
do
    > "$DIR/group_$i.csv"
done

counter=0
while IFS= read -r line
do
    if [ "$counter" -eq 0 ]; then
        counter=$((counter + 1))
        continue
    fi

    group=$(( (counter - 1) % 18 + 1 ))
    echo "$line" >> "$DIR/group_$group.csv"
    counter=$((counter + 1))
done < "$DIR/students.csv"

echo "✅ 1e. Students have been grouped"