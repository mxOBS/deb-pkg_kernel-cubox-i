#!/bin/bash
#
# part of this work was taken from the linux kernel tree on 11 December 2015
# Source: https://github.com/MarvellEmbeddedProcessors/linux-armada38x/tree/linux-3.10.70-15t1-clearfog
#
# Original Authors unknown
# License GPL-2.0+
#
#
# Script to install kernel headers
# License: MIT (or original license if incompatible)
#
# Copyright: 0000-2015 Original Authors
# Copyright: 2015 Josua Mayer
#

usage() {
	echo "$0 <architecture> <sourcedir> <builddir> <destdir>"
}

if [ "x$#" != "x3" ]; then
	usage
	exit 1
fi

SRCDIR="$1"
BUILDDIR="$2"
DESTDIR="$3"
TMPDIR="$PWD"

# snippet copied from kernel tree /scripts/package/builddeb
(cd "$SRCDIR"; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$TMPDIR/hdrsrcfiles")
(cd "$SRCDIR"; find arch/{arm,arm64}/include include scripts -type f >> "$TMPDIR/hdrsrcfiles")
(cd "$BUILDDIR"; find arch/{arm,arm64}/include .config Module.symvers include scripts -type f >> "$TMPDIR/hdrobjfiles")

mkdir -p "$DESTDIR"
(cd "$SRCDIR"; tar -c -f - -T "$TMPDIR/hdrsrcfiles") | (cd "$DESTDIR"; tar -xf -)
(cd "$BUILDDIR"; tar -c -f - -T "$TMPDIR/hdrobjfiles") | (cd "$DESTDIR"; tar -xf -)
rm -f "$TMPDIR/hdrsrcfiles" "$TMPDIR/hdrobjfiles"
