#!/bin/sh

rspec 2>/tmp/pdxspurs-warnings.txt
cat     /tmp/pdxspurs-warnings.txt | grep -v with_exclusive_scope 

