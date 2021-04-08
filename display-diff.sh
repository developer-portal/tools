#!/usr/bin/bash

git diff -w | grep -vE '^-\s*$' | grep -vE '^ ' | grep -vE '^index ' | grep -vE '^\+\+\+ ' | grep -vE '^\-\-\- ' | colordiff

