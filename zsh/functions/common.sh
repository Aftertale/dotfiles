#!/bin/zsh

# USAGE: in your function definition, call this with the required number of args and the arg themselves
function validate_inputs(){
  requiredArgs="$1"
  providedArgs=("${@:2}")
  if [[ "${#providedArgs[@]}" -eq "$requiredArgs" ]]; then
    return 0
  else
    return 1
  fi
}

function add_flag(){
  # get the options map to modify
  options_map="$1"
  option_name="$2"
  option_default_value="$3"
  
  # add new option to the provided map
  add_to_map_var $options_map "$option_name" "${option_default_value:-nil}"
}

# given an options map and a list of parameters, parse the flags and return a map of flags and values
function parse_flags() {
  options_map_var="$1"
  
  
  echo ${(kv)${(P)options_map_var}}
}

function parse_cmd() {
  declare -A userOpts
  declare -a userSubCommands
  while [[ $# -gt 0 ]]; do
    echo "working on: $1"
    case "$1" in
      -*)
        optName=${1//-/}
        optionKeys=${(k)OPTIONS}
        if (($FLAGS[(Ie)$optName])); then
          echo "$optName is a flag"
          userOpts[${optName}]=true
          shift
        elif (($optionKeys[(Ie)$optName])); then
          echo "$optName is an option"
          userOpts[${optName}]="$2"
          echo "before shift: $1 $2"
          shift
          echo "after shift 1: $1 $2"
          shift
          echo "after shift 2: $1 $2"
        else
          echo "$optName is unknown"
          shift
        fi
        ;;
      *)
        commandFuncName="$SUBCOMMANDS[${1}]"
        userSubCommands+=( "$commandFuncName" )
        shift
        ;;
    esac
  done
  echo "userOpts: ${(kv)userOpts}"
  echo "subCommands: ${(kv)userSubCommands}"
  eval $userSubCommands[1] $userOpts
}

function test_af(){
  # add_subcommand "test" "test_function"
  # add_flag "foo" "FOO" "defaultValue"
  # add_flag "bar" "BAR"
  # parse_flags
  declare -A myOpts
  add_flag myOpts foo bar
  add_flag myOpts baz
  parse_flags myOpts
}

function testTwo() {
  declare -A OPTIONS
  declare -a FLAGS
  declare -A SUBCOMMANDS

  # options have values
  OPTIONS=(
    [foo]=bar
    [baz]=nil
  )

  # flags are boolean
  FLAGS=(
    verbose
    v
  )

  SUBCOMMANDS=(
    ["test"]=test_function
    [create]=create_function
    ["read"]=read_function
  )

  echo "$@"
  parse_cmd "$@"
}

create_function() {
  echo "I am create function!"
  echo "\nI was called with args: $@"
}

read_function() {
  echo "I am read function!"
}

function test_function(){
  echo "I am test function!"
}

function add_to_map_var() {
    eval "$1+=( [$2]=$3 )"
}

function is_in_list() {
  newList="${${1}}"
  echo $newList
}

function get_from_map_var() {
  eval 'echo $'$1'['${2}']'
}

function get_from_map_ref() {

}

function assign_to_map_ref() {

}

function get_from_list_ref() {

}

function add_to_list_ref() {

}

