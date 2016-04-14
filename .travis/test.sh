#!/bin/sh

name=TravisTest
uno build TravisTest.unoproj -v
exitcode=$?
if [ $exitcode -ne 0 ]; then
	echo Failed uno $name : $exitcode
	exit $exitcode
fi
uno build -tiOS TravisTest.unoproj -v
exitcode=$?
if [ $exitcode -ne 0 ]; then
	echo Failed iOS $name : $exitcode
	exit $exitcode
fi
uno build -tAndroid TravisTest.unoproj -v
exitcode=$?
if [ $exitcode -ne 0 ]; then
	echo Failed Android $name : $exitcode
	exit $exitcode
fi