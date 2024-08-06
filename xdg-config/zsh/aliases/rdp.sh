#!/bin/zsh
function rdp() {
  open -a /Applications/Microsoft\ Remote\ Desktop.app "rdp://full%20address=s:$1"
}
