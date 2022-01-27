#!/bin/bash


if [ -f build/tex.c ]; then rm build/c.tex; fi
x=$(find build/ -maxdepth 1 -type f -name '*.tex' -not -name '*_recipe.tex' | sort)

touch build/c.tex
> build/c.tex
cat _templates/cookbook.tex > build/c.tex

for file in $x
do
	echo "{$file}"
	cat $file >> build/c.tex
done

for folder in build/**/
do
	section=$(echo "${folder:6:-1}" | sed 's/_/ /g')
	section=$(echo "$section" | head -c 1 | tr [:lower:] [:upper:])$(echo "${section:1}")
	echo "\chapter{$section}" >> build/c.tex

	x=$(find $folder -type f -name '*.tex' -not -name '*_recipe.tex' | sort)
	for file in $x
	do
		echo "{$file}"
		cat $file >> build/c.tex
	done
done

echo "\end{document}" >> build/c.tex
