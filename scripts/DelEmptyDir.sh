#!/bin/sh
ThS=/vmfs/volumes/d37ea5e1-3d5ef890/BackUpVMS/*
NxS=/vmfs/volumes/02bd7f89-ec097b21/BackUpVMS/*
###################################################################################
rmdir --ignore-fail-on-non-empty $ThS
rmdir --ignore-fail-on-non-empty $NxS
