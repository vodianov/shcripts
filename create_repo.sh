#!/usr/bin/env bash

# Set default values for the named parameters
name=""
repo_name=""
license=""

# Parse the command-line options using getopts
while getopts "n:r:l" opt; do
  case ${opt} in
	n ) name="$OPTARG";;
	l ) license="$OPTARG";;
	r ) repo_name="$OPTARG";;
	\? ) echo "Invalid option: -$OPTARG" 1>&2; exit 1;;
	: ) echo "Option -$OPTARG requires an argument" 1>&2; exit 1;;
  esac
done
shift $((OPTIND -1))

# Print the named parameters
echo "Name: $name"
echo "Age: $age"
echo "License: $license"
