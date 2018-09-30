#!/bin/bash

source ${AT_BASE_DIR}/utils/extra_symbols.sh
source ${AT_BASE_DIR}/utils/text.sh

# general variables
DEFAULT_TEXT_FG=${TEXT_FG_BLACK}
DEFAULT_TEXT_BG=${TEXT_BG_LIGHT_GREEN}
TEXT_SEPARATOR=' '\\u${CODEPOINT_OF_DOT}' '
LEFT_PROMPT_START=${DEFAULT_TEXT_BG}${DEFAULT_TEXT_FG}
LEFT_PROMPT_END=\\u${CODEPOINT_OF_RIGHT_ANGLE_QUOTATION_MARK}${TEXT_STYLE_REVERSE}\\u${CODEPOINT_OF_BREADCRUMB_RIGHT}${TEXT_STYLE_RESET_ALL}
RIGHT_PROMPT_START="${LEFT_PROMPT_START}\\u${CODEPOINT_OF_BREADCRUMB_RIGHT} "
RIGHT_PROMPT_END=

# dvcs-related variables
DVCS_DETECT_ENABLED=true
DIRTY_BRANCH_TEXT_FG=${TEXT_FG_LIGHT_RED}
DIRTY_BRANCH_ICON=
CLEAN_BRANCH_TEXT_FG=${TEXT_FG_BLUE}
CLEAN_BRANCH_ICON=
DEFAULT_GIT_ICON=\\u${CODEPOINT_OF_LEFT_ANGLE_QUOTATION_MARK}'git @ '
GITHUB_ICON=\\u${CODEPOINT_OF_LEFT_ANGLE_QUOTATION_MARK}'github @ '
GITLAB_ICON=\\u${CODEPOINT_OF_LEFT_ANGLE_QUOTATION_MARK}'gitlab @ '
HG_ICON=\\u${CODEPOINT_OF_LEFT_ANGLE_QUOTATION_MARK}'hg @'
BRANCH_ICON=

# cwd-related variables
CWD_DETECT_ENABLED=true
HOME_ICON=\\u${CODEPOINT_OF_TENT}
PATH_SEPARATOR=\\u${CODEPOINT_OF_BREADCRUMB_RIGHT_OUTLINE}

# battery-related variables
BATTERY_DETECT_ENABLED=true
BATTERY_CHARGING_ICON=\\u26a1
BATTTERY_LEVEL_ICONS=(\\u${CODEPOINT_OF_BATTERY_ONE_EIGTH} \\u${CODEPOINT_OF_BATTERY_TWO_EIGTH} \\u${CODEPOINT_OF_BATTERY_THREE_EIGTH} \\u${CODEPOINT_OF_BATTERY_FOUR_EIGTH} \\u${CODEPOINT_OF_BATTERY_FIVE_EIGTH} \\u${CODEPOINT_OF_BATTERY_SIX_EIGTH} \\u${CODEPOINT_OF_BATTERY_SEVEN_EIGTH} \\u${CODEPOINT_OF_BATTERY_FULL})

# time and date related variables
DATE_ICON=
TIME_ICON=\\u23F2