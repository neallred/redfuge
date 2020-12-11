#!/usr/bin/env bash

sudo journalctl -u ssh --since "1 week ago" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort -n | uniq
