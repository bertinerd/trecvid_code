#!/bin/bash
 
while getopts ":ab" opt; do
  case $opt in
    a)
      echo "-a was triggered!" >&2
      ;;
    b) 
      echo "-b was triggered!" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done