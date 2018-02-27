#!/usr/bin/env bash
#
# source this file to get color definitions
# if $debug or $verbose is set, the definitions
# are also printed to STDERR.
#
# taken from magicmonty/bash-git-prompt (where it's called 'prompt-colors.sh')
# and tweaked because I want more possibilities

define_color_names() {

  ColorNames=( Black Red Green Yellow Blue Magenta Cyan White )
  FgColors=(    30   31   32    33     34   35      36   37  )
  BgColors=(    40   41   42    43     44   45      46   47  )

  local AttrNorm=0
  local AttrBright=1
  local AttrDim=2
  local AttrUnder=4
  local AttrBlink=5
  local AttrRev=7
  local AttrHide=8

  # define "BoldCOLOR", "BrightCOLOR", and "DimCOLOR" names

  # _map_colors ATTRNAME ATTRVALUE
  #
  # Defines some names for every color / attribute combination:
  #    {ATTRNAME}{COLORNAME}
  #    {ATTRNAME}{COLORNAME}Fg
  #    {ATTRNAME}{COLORNAME}Bg
  #
  # Example: BoldRed, BoldRedFg, BoldRedBg

  _map_colors() {
    local x=0
    local attrname="$1"
    local attrcode=$2
    while (( x < 8 )) ; do
      local colorname=${ColorNames[x]}
      local fgcolorcode=${FgColors[x]}
      local bgcolorcode=${BgColors[x]}
      longcolorname="${attrname}${colorname}"
      _def_color $longcolorname     $attrcode $fgcolorcode
      _def_color ${longcolorname}Fg $attrcode $bgcolorcode
      _def_color ${longcolorname}Bg $attrcode $bgcolorcode
      (( x++ ))
    done
  }

  # _term_color [ N | N M ]
  _term_color() {
    local cv
    if (( $# > 1 )); then
      cv="${1};${2}"
    else
      cv="${1}"
    fi
    echo "\[\033[${cv}m\]"
  }

  # def_color NAME ATTRCODE COLORCODE
  _def_color() {
    local def="$1=\"\`_term_color $2 $3\`\""
    if [[ -n "$debug$verbose" ]]; then
      echo 1>&2 "+ $def"
    fi
    eval "$def"
  }

  _map_colors Bold   $AttrBright
  _map_colors Bright $AttrBright
  _map_colors Dim    $AttrDim
  _map_colors ''     $AttrNorm

  # just the attributes on their own
  _def_color Bold   $AttrBright
  _def_color Bright $AttrBright
  _def_color Dim    $AttrDim
  _def_color Under  $AttrUnder
  _def_color Blink  $AttrBlink
  _def_color Inv    $AttrRev
  _def_color Rev    $AttrRev
  _def_color Hide   $AttrHide

  _def_color IntenseBlack 0 90
  _def_color ResetColor   0

}

# do the color definitions only once
if [[ ${#ColorNames[*]} = 0 || -z "$IntenseBlack" || -z "$ResetColor" ]]; then
  define_color_names
fi
