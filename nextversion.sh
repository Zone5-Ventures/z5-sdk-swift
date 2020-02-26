#!/bin/bash
echo 'Incrementing version and build number from' `agvtool what-marketing-version -terse1`'.'`agvtool what-version -terse` 'to' $1'.'$((`agvtool what-version -terse`+1))
agvtool new-marketing-version $1
agvtool next-version -all
