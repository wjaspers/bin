#!/bin/sh

git log --all --format='%aN <%cE>' | sort -u
