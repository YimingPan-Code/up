#!/bin/bash

# run any bash shell
# ignore all *.gsql file
if [[ "$@" =~ .sh$ ]]; then
  echo "Runing bash file: $@"
  bash "$@"
else
  echo "Ignore file: $@"
fi
