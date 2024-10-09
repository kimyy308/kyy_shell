#!/bin/csh

set abc=`ls s`
#if ( -n "$abc" )
if ( ${abc} == "" ) then
 echo "abc"
else if then
 echo "bcd"
endif
