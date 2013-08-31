#!/bin/bash
#
# Show various system info depending on a current (system) dir
#
# Copyright (c) 2013 Alex Turbov <i.zaufi@gmail.com>
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#

function _60_is_empty_dir()
{
    local _content=`ls`
    return `test -z "${_content}"`
}

# Check if current directory is /usr/src/linux and latter is a symbolic link
function _60_is_usr_src_linux_dir()
{
    local _cur=`pwd`
    return `test "${_cur}" = '/usr/src/linux' -a -L "${_cur}"`
}

function _61_is_linked_dir()
{
    return `readlink -q \`pwd\` >/dev/null`
}

function _61_is_boot_or_run_dir()
{
    local _cur=`pwd`
    return `test "${_cur}" = '/boot' -o "${_cur}" = '/run'`
}

function _61_is_proc_dir()
{
    local _cur=`pwd`
    return `test "${_cur}" = '/proc'`
}


# TODO Make sure /proc is available
function _show_kernel_and_uptime()
{
    local _kernel=`uname -r`
    local _seconds=`sed 's,\([0-9]\+\)\..*,\1,' /proc/uptime`
    local _uptime
    _seconds_to_duration ${_seconds} _uptime

    printf "${sp_debug}${_kernel}${sp_path}${sp_seg_delim}${sp_misc}${_uptime}"
}

function _show_processes_and_load()
{
    local _load=`cat /proc/loadavg | cut -d ' ' -f 1,2,3`
    local _psax_wc_l=`ps ax --no-headers | wc -l`
    local _psu_wc_l=`ps -u $USER --no-headers | wc -l`
    local _all_processes=$(( ${_psax_wc_l} - 2))
    local _user_processes=$(( ${_psu_wc_l} - 2))

    printf "${sp_debug}${_user_processes}/${_all_processes}${sp_path}${sp_seg_delim}${sp_debug}${_load}"
}

function _show_kernel_link()
{
    local _link_to=`readlink \`pwd\``
    printf "${sp_debug}link -> ../${_link_to}${sp_path}"
}

function _show_dir_link()
{
    local _link_to=`readlink \`pwd\``
    printf "${sp_debug}link-> ${_link_to}${sp_path}"
}

function _show_empty_mark()
{
    printf "${sp_debug}empty dir${sp_path}"
}

SMART_PROMPT_PLUGINS[_60_is_empty_dir]=_show_empty_mark
SMART_PROMPT_PLUGINS[_60_is_usr_src_linux_dir]=_show_kernel_link
SMART_PROMPT_PLUGINS[_61_is_linked_dir]=_show_dir_link
SMART_PROMPT_PLUGINS[_61_is_boot_or_run_dir]=_show_kernel_and_uptime
SMART_PROMPT_PLUGINS[_61_is_proc_dir]=_show_processes_and_load
