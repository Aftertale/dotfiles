#compdef _goto goto

function _goto {
  local line

  _arguments -C \
    "-h[Show help information]" \
    "--help[Show help information]" \
    "1: :(add list remove)" \
    "*::arg:->args"

  case $line[1] in
    add)
      _arguments -C \
        "-h[Show help information]" \
        "--help[Show help information]" \
        "1: :(add)" \
        "2: :(add)" \
        "*::arg:->args"
      ;;
    list)
      _arguments -C \
        "-h[Show help information]" \
        "--help[Show help information]" \
        "1: :(list)" \
        "*::arg:->args"
      ;;
    remove)
      _arguments -C \
        "-h[Show help information]" \
        "--help[Show help information]" \
        "1: :(remove)" \
        "2: :(remove)" \
        "*::arg:->args"
      ;;
    *)
      _arguments -C \
        "-h[Show help information]" \
        "--help[Show help information]" \
        "*::arg:->args"
      ;;
  esac
}
