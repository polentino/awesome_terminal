#!/bin/bash

# Function that's responsible to detect if the current working directory is under
# (distributed) version control system and, if so, retrieves basic infos to the
# variable passed as parameter.
# Supported DVCS: Git, Mercurial (when installed)
#
# Requires:
#   - `git` command installed and available in the current $PATH
#   - `hg`  command installed and available in the current $PATH
#
# Expected variables:
#   - DEFAULT_TEXT_FG       the default font color
#   - DIRTY_BRANCH_TEXT_FG  the font color when the branch is dirty
#   - DIRTY_BRANCH_ICON     the icon when the branch is dirty
#   - CLEAN_BRANCH_TEXT_FG  the font color when the branch is clean
#   - CLEAN_BRANCH_ICON     the icon when the branch is clean
#   - GITHUB_ICON           the icon/text to be used if the directory managed by git, and hosted in github
#   - GITLAB_ICON           the icon/text to be used if the directory managed by git, and hosted in gitlab
#   - DEFAULT_GIT_ICON      the icon/text to be used by default, if the directory is managed by git
#   - HG_ICON               the icon/text to be used if the project managed by mercurial
#   - TEXT_SEPARATOR        something used to be placed between the path string, and the dvcs info string
#
# Sets:
#   - $1                    the reference to the variable passed as parameter
function dvcs_detect {

  local BRANCH=""
  local ICON=""

  # is it a GIT repository?
  if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == true ]] ; then
    BRANCH=$(git symbolic-ref --short HEAD)
    if [[ $(git status -s -uno | wc -l) != 0 ]] ; then
      BRANCH=${DIRTY_BRANCH_TEXT_FG}${BRANCH}${DEFAULT_TEXT_FG}
      if [ ! -z "${DIRTY_BRANCH_ICON}" ] ; then
        ICON=" ${DIRTY_BRANCH_ICON} "
      fi
    else
      BRANCH=${CLEAN_BRANCH_TEXT_FG}${BRANCH}${DEFAULT_TEXT_FG}
      if [ ! -z "${CLEAN_BRANCH_ICON}" ] ; then
        ICON=" ${CLEAN_BRANCH_ICON} "
      fi
    fi

    local remote_url=$(git config --get remote.origin.url)
    if [[ $remote_url = *"github.com"* ]] ; then
      GIT_LOGO=$GITHUB_ICON
    elif [[ $remote_url = *"gitlab.com"* ]] ; then
      GIT_LOGO=$GITLAB_ICON
    else
      GIT_LOGO=${DEFAULT_GIT_ICON}
    fi

    # TODO find good branch icon
    eval "$1='${TEXT_SEPARATOR}${GIT_LOGO} ${BRANCH}${ICON}'"

  # is this a Mercurial repository?
  elif [[ "$(hg branch 2> /dev/null)" != "" ]] ; then
    if [[ "$(hg branch)" != "" ]] ; then
      BRANCH=${DIRTY_BRANCH_TEXT_FG}${BRANCH}${DEFAULT_TEXT_FG}
      if [ ! -z "${DIRTY_BRANCH_ICON}" ] ; then
        ICON=" ${DIRTY_BRANCH_ICON}"
      fi
    else
      BRANCH=${CLEAN_BRANCH_TEXT_FG}${BRANCH}${DEFAULT_TEXT_FG}
      if [ ! -z "${CLEAN_BRANCH_ICON}" ] ; then
        ICON=" ${CLEAN_BRANCH_ICON}"
      fi
    fi

    # TODO find good branch icon
    eval "$1='${TEXT_SEPARATOR}${HG_ICON}${BRANCH}${ICON}'"

  else
    eval "$1=' '"
  fi
}

# Function that's responsible to detect the current working directory, and manipulate it
# to make it a bit good looking :)
#
# Expected variables:
#   - HOME_ICON      the icon/text to be used instead of /home/$USER/
#   - PATH_SEPARATOR the icon/text to be used instead of the path separator
#
# Sets:
#   - $1             the reference to the variable passed as parameter
function cwd_detect {
  # show the 'home' icon if the path starts with /home/username
  local CP=''
  if [[ $PWD == /home/$USER* ]] ; then
    CP=${PWD/"/home/$USER"/$HOME_ICON}
  else
    CP=${PWD#?}
  fi
  eval "$1='${CP//\// $PATH_SEPARATOR }'"
}

# Function that's responsible to detect battery charge level and adapter status (either
# connected/disconnected).
#
# Requires:
#   - `upower` command installed and available in the current $PATH
#
# Expected variables:
#   - BATTERY_CHARGING_ICON      the icon/text to be used when the AC adapter is plugged in
#   - BATTTERY_LEVEL_ICONS       array of 8 icons/texts to be used instead for a specific charge range
#
# Sets:
#   - $1             the reference to the variable passed as parameter
function battery_detect {
  # detect battery charge and AC adapter
  local charger_status_icon=''
  if [[ $(cat /sys/class/power_supply/ADP1/online 2> /dev/null) == 1 ]] ; then
    charger_status_icon=${BATTERY_CHARGING_ICON}
  fi

  local battery_charge=$(upower -i $(upower -e | grep '/battery') | grep --color=never -E percentage|xargs|cut -d' ' -f2|sed s/%// 2> /dev/null)
  if [[ $battery_charge -gt 92 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[7]}
  elif [[ $battery_charge -gt 78 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[6]}
  elif [[ $battery_charge -gt 64 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[5]}
  elif [[ $battery_charge -gt 50 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[4]}
  elif [[ $battery_charge -gt 36 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[3]}
  elif [[ $battery_charge -gt 22 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[2]}
  elif [[ $battery_charge -gt 10 ]] ; then
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[1]}
  else
    battery_charge_icon=${BATTTERY_LEVEL_ICONS[0]}
  fi
  eval "$1='${charger_status_icon} ${battery_charge_icon}'"
}
