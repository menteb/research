#!/usr/bin/env bash

# Copyright (C) 2021 Bram J. De Smet <bram@cerebralmisfire.net>. All Rights Reserved.
# This file is licensed under the GPLv3+. Please see LICENSE for more information.

set -o pipefail

PREFIX="${RESEARCH_STORE_DIR:-$HOME/Documents/Research}"
ARTICLES="${RESEARCH_ARTICLES_DIR:-$PREFIX/Articles}"
BOOKS="${RESEARCH_BOOKS_DIR:-$PREFIX/Books}"
NOTES="${RESEARCH_NOTES_DIR:-$PREFIX/Notes}"
GLOBALBIB="${RESEARCH_GLOBALBIB:-$PREFIX/global.bib}"
TAGS="${RESEARCH_TAGS:-$PREFIX/tags}"
KEYWORDS="${RESEARCH_KEYWORDS:-$PREFIX/keywords}"
CITEFORMAT="${RESEARCH_CITEFORM:-chicago}" # apa, chicago, harvard, mla, vancouver
EDITOR="${RESEARCH_EDITOR:-vi}"
PDFREADER="${RESEARCH_PDFREADER:-adobe}"
EDITMODE="${RESEARCH_EDITMODE:-both}" # note, pdf, both
RESEARCHER=$RESEARCH_RESEARCHER

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
# BEGIN functions
#

cmd_getdoi() {
	# Search in PDF: pdftotext ${filename} - | grep -oP "10.\d{4,9}\/[-._;()/:A-Za-z0-9]+" | head -n 1
	# Check 1: inside PDFINFO
	# Check 2: inside PDF text
	#	Check 2.1: DOI found
	#	Check 2.2: DOI not found ==> JSTOR URL? ==> get /stable/xxxxxxxxx ==> DOI = 10.2307/xxxxxxxxxx
	# OPTIONAL Check: last attempt: check title curl -s "https://api.crossref.org/works?query.container-title=$title" | jq ".message.items[0].DOI" | sed -e "s/\"//g" 
	# ASK: 
	# Unable to find DOI from PDF file. Either provide DOI or Skip
	# Options: [d]OI | [s]kip
	# Action: <enter>
	# {if DOI}
	# DOI: <enter>

	# DOI found: $DOI
	echo "getdoi"
}

cmd_getbib() {
	# Once we have DOI: curl -s "http://api.crossref.org/works/10.1016/$doi/transform/application/x-bibtex"
	#[[ -n $1 ]] || return
	#echo "DOI: $1"
	bib=$(curl -s "http://api.crossref.org/works/$1/transform/application/x-bibtex")
	title_raw=$(echo "$bib" | sed -n '1p' | cut -d{ -f2 | sed 's/,//')
	title=${title_raw,,}
	echo $title

	cat <<-_EOF

	Bibliography retireved:

	$bib
	_EOF
}

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
		$PROGRAM import [-c, --copy | -m, --move] file(s)
			Import one or more PDF files and either copy or move them into the directory structure.
			Defaults to copy action. Default can be set in config. See research(1) man for more information.
		$PROGRAM open author_year
			This will open the Markup file for note taking, and the PDF.
			Default editor is set to ${EDITOR:-vi}.
			Default PDF application is set to
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
	help) shift;	cmd_usage "$@" ;;
	config) shift;	cmd_config "$@";;
	version) shift;	cmd_version "$@" ;;
	test) shift;	cmd_getbib "$@" ;;
esac
exit 0
