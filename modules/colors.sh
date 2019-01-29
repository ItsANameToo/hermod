#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# This file is part of hermod.
#
# (c) ItsANameToo <itsanametoo@protonmail.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
# ---------------------------------------------------------------------------

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
lila=$(tput setaf 4)
pink=$(tput setaf 5)
blue=$(tput setaf 6)
white=$(tput setaf 7)
black=$(tput setaf 8)

bg_red=$(tput setab 1)
bg_green=$(tput setab 2)
bg_yellow=$(tput setab 3)
bg_lila=$(tput setab 4)
bg_pink=$(tput setab 5)
bg_blue=$(tput setab 6)
bg_white=$(tput setab 7)
bg_black=$(tput setab 8)

bold=$(tput bold)
reset=$(tput sgr0)

heading()
{
    echo "${lila}⠳${reset}${bold} $1${reset}"
}

success()
{
    echo "${green}⠳${reset}${bold} $1${reset}"
}

info()
{
    echo "${blue}⠳${reset}${bold} $1${reset}"
}

warning()
{
    echo "${yellow}⠳${reset}${bold} $1${reset}"
}

error()
{
    echo "${red}⠳${reset}${bold} $1${reset}"
}

heading_solid()
{
    echo "${bg_black}${lila}==>${reset}${bg_black}${bold} $1${reset}"
}

success_solid()
{
    echo "${bg_black}${green}==>${bold} $1${reset}"
}

info_solid()
{
    echo "${bg_black}${blue}==>${bold} $1${reset}"
}

warning_solid()
{
    echo "${bg_black}${yellow}==>${bold} $1${reset}"
}

error_solid()
{
    echo "${bg_black}${red}==>${bold} $1${reset}"
}
