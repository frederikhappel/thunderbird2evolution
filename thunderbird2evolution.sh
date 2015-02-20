#!/bin/bash
################################################################################
# Date:     2015/02/20
# Author:   Frederik Happel <mail@frederikhappel.de>
#
# This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Purpose:
#   Convert mbox (especially thunderbird) mailboxes with folder structure
#   recursively to Gnome Evolution maildir format
#
# History:
#   2015/02/20 first release
#
################################################################################

# get parameters
srcdir=$1
dstdir=$2

# print usage
function usage() {
  progname=$(basename ${BASH_SOURCE[0]})
  echo "usage: ${progname} <srcdir> <dstdir>"
  exit 1
}

# sanity checks
mb2md_binary=$(which mb2md)
if [ ! -e ${mb2md_binary} ] || [ ! -x ${mb2md_binary} ] ; then
  echo "mb2md was not found. please install"
  exit 1
elif [ -z "${srcdir}" ] ; then
  usage  
elif [ -z "${dstdir}" ] ; then
  echo "<dstdir> cannot be empty"
  exit 1
elif [ ! -d "${srcdir}" ] ; then
  echo "'${srcdir}' is not an existing directory"
  exit 1
fi

# workhorse
curdir=$(pwd)
cd ${srcdir}
find * -type f | egrep -v "\.(sbd|msf|dat)$" | while read mbox ; do
  mbox_new=$(echo "${mbox}" | sed 's/\.sbd//g' | sed 's/\./_2E/g' | sed 's/\//\./g')
  mbox_new="${dstdir}/..${mbox_new}"
  if [ -d "${mbox_new}" ] ; then
    echo "maildir '${mbox_new}' already existing. skipping"
  else
    mkdir -p "${mbox_new}"
    ${mb2md_binary} -s "./${mbox}" -d "${mbox_new}"
  fi
done
cd ${curdir}

exit 0

