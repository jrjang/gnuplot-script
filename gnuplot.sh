#!/bin/bash

#
# parameters:
#  --input
#  --output: file (default: output.svg)
#  --terminal: svg
#  --xlabel
#  --ylabel
#

OUTPUT=output.svg
TERMINAL=svg

for var in $@; do
	if [[ $var =~ '--input' ]]; then
		INPUT=${var#*--input=}

		if ! [ -f $INPUT ]; then
			echo "Can not find $INPUT!"
			exit 1
		fi

		pushd `dirname $INPUT` >& /dev/null
		INPUT=`pwd`/`basename $INPUT`
		popd >& /dev/null
	fi
	if [[ $var =~ '--output' ]]; then
		OUTPUT=${var#*--output=}
	fi
	if [[ $var =~ '--terminal' ]]; then
		TERMINAL=${var#*--terminal=}
	fi
	if [[ $var =~ '--xlabel' ]]; then
		XLABEL=${var#*--xlabel=}
	fi
	if [[ $var =~ '--ylabel' ]]; then
		YLABEL=${var#*--ylabel=}
	fi
done

tmp_script=`mktemp`
cat > $tmp_script <<EOF
#!/usr/bin/env gnuplot

set terminal $TERMINAL
set xlabel "$XLABEL"
set ylabel "$YLABEL"
plot "$INPUT" with lines
EOF

chmod a+x $tmp_script
$tmp_script > $OUTPUT
rm $tmp_script
