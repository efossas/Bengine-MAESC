#!/bin/bash
 
if [ $# -ne 1 ]
then
  echo "Usage: build.sh [tag]";
  exit 1;
else
  docker build --no-cache -f Dockerfile -t "$1"/bengine:latest .
fi

