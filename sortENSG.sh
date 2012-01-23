#!/bin/bash

head -n 1 $1
tail -n +2 $1 | sort
