#!/usr/bin/env bash

# Copyright (C) 2021 Bram J. De Smet <bram@cerebralmisfire.net>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

set -o pipefail

PREFIX="${RESEARCH_STORE_DIR:-$HOME/Documents/Research}"
ARTICLES="${RESEARCH_STORE_DIR:-$HOME/Documents/Articles}"
BOOKS="${RESEARCH_STORE_DIR:-$HOME/Documents/Books}"
NOTES="${RESEARCH_STORE_DIR:-$HOME/Documents/Notes}"
GLOBALBIB="$PREFIX/global.bib"
TAGS="$PREFIX/tags"
KEYWORDS="$PREFIX/keywords"

#
# BEGIN helper functions
#

yesno() {
	[[ -t 0 ]] || return 0
	local response
	read -r -p "$1 [y/N] " response
	[[ $response == [yY] ]] || exit 1
}
die() {
	echo "$@" >&2
	exit 1
}

#
# END helper functions
#

#
# BEGIN subcommand functions
#

cmd_config() {
    cat <<-_EOF
    General: $PREFIX
    Articles: $ARTICLES
    Books: $BOOKS
    Global bib file: $GLOBALBIB
    Tags file: $TAGS
    Keywords file: $KEYWORDS
    
    These directories can be set in your ENV. See research(1) man page for more information. 
_EOF
}

cmd_version() {
	cat <<-_EOF
    research: the academic tool for nerds
    version: v0.1
    Get involved: https://github.com/menteb/research
_EOF
}

#
# END subcommand functions
#

cmd_usage() {
	cmd_version
	echo
	cat <<-_EOF
	Usage:
	    $PROGRAM help
	        Show this text.
        $PROGRAM config
            Show directory configuration
	    $PROGRAM version
	        Show version information.

	More information may be found in the research(1) man page.
_EOF
}

#
# END subcommand functions
#

PROGRAM="${0##*/}"
COMMAND="$1"

case "$1" in
	help|--help) shift;		cmd_usage "$@" ;;
    config|--config) shift; cmd_config "$@";;
	version|--version) shift;	cmd_version "$@" ;;
esac
exit 0
