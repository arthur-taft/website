# BSDmakefile
#
# Copyright (c) 2026 Arthur Taft. All Rights Reserved.
#
# FreeBSD's make(1) reads BSDmakefile in preference to makefile and Makefile.
# The real build lives in Makefile and uses GNU make syntax (wildcard,
# patsubst, shell, pattern rules), so hand every target off to gmake.
#
#   # pkg install gmake
#
# On Linux, GNU make ignores this file and reads Makefile directly.

.PHONY: help build all test serve deploy rebuild clean

help build all test serve deploy rebuild clean:
	@gmake --no-print-directory ${.TARGET}
