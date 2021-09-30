#!/bin/bash


if [[ "$1" =~ schema.gsql$ ]]; then
  echo "Skip run schema file: $1"
  exit 0
else
  echo "Run query file: $1"
fi

# test level actually should be same as end2end
export GSHELL_TEST=_GSQL^TEST^WARN_

gsql $1
