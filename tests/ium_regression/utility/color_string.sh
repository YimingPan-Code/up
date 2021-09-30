#! /bin/bash

# Color Define
Black="0;30"
DarkGray="1;30"
Red="0;31"
LightRed="1;31"
Green="0;32"
LightGreen="1;32"
Orange="0;33"
Yellow="1;33"
Blue="0;34"
LightBlue="1;34"
Purple="0;35"
LightPurple="1;35"
Cyan="0;36"
LightCyan="1;36"
LightGray="0;37"
White="1;37"

# make color string
# $1 returned colored string
# $2 color listed above
# $3 raw string
function ColorString() {
  local _outval=$1
  local _result
  EnableColor='\033['$2'm'
  DisableColor='\033[0m'
  _result=${EnableColor}$3${DisableColor}
  eval $_outval=\$_result
}

GreenString() {
  ColorString $1 $Green "$2"
}

LightRedString() {
  ColorString $1 $LightRed "$2"
}

RedString() {
  ColorString $1 $Red "$2"
}

BlueString() {
  ColorString $1 $Blue "$2"
}

# example
# GreenString ABC "123"
# echo -e $ABC


