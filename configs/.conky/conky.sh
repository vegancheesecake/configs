#!/bin/sh

# Send the header so that i3bar knows we want to use JSON:
echo '{"version":1}'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[],'

# Now send blocks with information forever:
if [ "$1" == "left" ]; then
	exec conky -c $HOME/.conky/.conkyrc_left
else
	exec conky -c $HOME/.conky/.conkyrc_right
fi
