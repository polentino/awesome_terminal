#!/usr/bin/env bash

AT_BASE_DIR=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source ${AT_BASE_DIR}/utils/helpers.sh
source ${AT_BASE_DIR}/themes/crumby.grayscale.sh

# TODO: support different OSes (see hints here https://unix.stackexchange.com/questions/9501/how-to-test-what-shell-i-am-using-in-a-terminal)
#       with zsh in fact, all the trickery to print the battery/date/time on the right side is not needed at all
# SHELL_TYPE=$(ps -p$$ -ocmd=)

function _prompt_bash_set {

  local CWD_PROMPT="\w"
  if [[ ${CWD_DETECT_ENABLED} == true ]] ; then
    cwd_detect CWD_PROMPT
  fi

  local DVCS_PROMPT=""
  if [[ ${DVCS_DETECT_ENABLED} == true ]] ; then
    dvcs_detect DVCS_PROMPT
  fi

  local BATTERY_PROMPT=""
  if [[ ${BATTERY_DETECT_ENABLED} == true ]] ; then
    battery_detect BATTERY_PROMPT
  fi

  # adapted from https://superuser.com/questions/187455/right-align-part-of-prompt/1203400#1203400
  printf -v RIGHT_PROMPT "${RIGHT_PROMPT_START}${BATTERY_PROMPT} ${DATE_ICON} %(%b %d ${TIME_ICON} %H:%M)T   ${RIGHT_PROMPT_END}" -1 # -1 is current time

  # Strip ANSI commands before counting length
  # From: https://www.commandlinefu.com/commands/view/12043/remove-color-special-escape-ansi-codes-from-text-with-sed
  RIGHT_PROMPT_STRIPPED=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$RIGHT_PROMPT")

  # tentative fix for fontawesome characters: they take twice the space
  IFS='\\u' inarr=(${RIGHT_PROMPT_STRIPPED})
  local correction=$((${#inarr[@]}*2))
  unset IFS

  LEFT_PROMPT=${LEFT_PROMPT_START}' '${CWD_PROMPT}${DVCS_PROMPT}${LEFT_PROMPT_END}' '
  # Reference: https://en.wikipedia.org/wiki/ANSI_escape_code
  printf -v PS1 "\[\e[s\e[$(tput cols)C\e[$((${#RIGHT_PROMPT_STRIPPED} - ${correction}))D${RIGHT_PROMPT}\e[u\]$LEFT_PROMPT"
}

PROMPT_COMMAND='_prompt_bash_set'
