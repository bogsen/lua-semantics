#!/bin/bash

kompile -v --debug lua.k || exit 1
echo

for test in tests/*.lua; do
	echo -n "Running ${test}... "
	output=$(timeout 120s ./luakrun --lib Test.More --debug "$test")
	state=$(echo "$output" | tail -n1)
	if echo "$output" | tail -n1 | grep "<k> \. </k>" | grep -q "<fstack> \.List </fstack>"; then
		echo "OK"
		echo "$output" | head -n -1
	else
		echo "Fail"
		echo "$output"
		exit 1
	fi
	echo
done
