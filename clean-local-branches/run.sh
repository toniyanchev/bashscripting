#!/bin/bash

git branch | grep -v "develop" | grep -v "master" | grep -v "main" | xargs git branch -D

exit 0
