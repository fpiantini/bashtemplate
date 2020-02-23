#!/usr/bin/env bash
# See https://dev.to/thiht/shell-scripts-matter for additional details
#
# Please, always check your scripts with "shellcheck"
#

set -euo pipefail
IFS=$'\n\t'

#/ Description:
#/   A template for safe and fun bash scripting
#/
#/ Usage:
#/   script_template.sh [options] mandatory_parameter
#/ Options:
#/   -a|--anoptionwitharg: an option with arg
#/   -b|--anoptionwithoutarg: an option without arg
#/   mandatory_parameter: mandatory final parameter
#/   --help: Display this help message
#/
#/ Examples:
#/   script_template.sh myparam
#/   script_template.sh -a option_a myfinalparam
#/   script_template.sh -a option_a -b myfinalparam
#/   script_template.sh --help
#/
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

cleanup() {
  info "cleanup called"
  # Remove temporary files
  # Restart services
  # ...
}

# ------------------------------------------------------------------------
init_environment() {

  # uncomment if you need them
  #_myabspathname=$(realpath "$0")
  #_myname=$(basename "$0")
  #_mydir=$(dirname "$_myabspathname")

  _something=""
  _something_else=false
  _mandatory_param=""
}

# ------------------------------------------------------------------------
parse_command_line() {

  while [[ $# -gt 1 ]]
  do
    key="$1"

    case $key in
      # examples...
      -a|--anoptionwitharg)
        _something="$2"
        shift # past argument
        ;;
      -b|--anoptionwithoutarg)
        _something_else=true
        ;;
      *)
        warning "ignoring unknown option $key"
        # unknown option
        ;;
    esac

    shift # past argument or value
  done

  # final mandatory args
  if [[ $# -gt 0 ]]; then
    _mandatory_param=$1
  else
    fatal "missing mandatory parameter"
  fi

}

# ------------------------------------------------------------------------
check_environment() {

  info "check_environment called"
  # examples

  if [ "${_something_else,,}" != "true" ] && [ "${_something_else,,}" != "false" ]; then
  ##if [[ "${_something_else,,}" != "true" && "${_something_else,,}" != "false" ]]; then
    warning "Wrong value for anoptionwithoutarg"
    usage
    exit 1
  fi

  if [[ -z "$_mandatory_param" ]]; then
    warning "Mandatory parameter missing."
    usage
    exit 1
  fi

  info "something = $_something"
  info "something else = $_something_else"
  info "mandatory parameter = $_mandatory_param"
}

# ------------------------------------------------------------------------
do_everything() {

  info "do_everything called"

}

# ------------------------------------------------------------------------
# MAIN
# ------------------------------------------------------------------------
main() {
  # --- initializations --------------
  init_environment
  parse_command_line "$@"
  check_environment

  # Do the real job of this script...
  do_everything

  # ----------------------------------
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  trap cleanup EXIT
  # Script goes here
  # ...
  main "$@"
  exit 0
fi

