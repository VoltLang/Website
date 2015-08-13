#!/bin/bash
URL=https://raw.githubusercontent.com/VoltLang/Volta/master/

function up-md {
	cat _script/md-template.txt > $2
	wget $URL/$1 -O - >> $2
}

function up-rst {
	wget $URL/$1 -O - | rst2html --template=_script/rst-template.txt > $2
}

up-md  doc/volt.md      doc/volt.md
up-rst doc/overview.rst doc/overview.html
