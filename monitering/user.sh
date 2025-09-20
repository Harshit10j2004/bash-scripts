#!/bin/bash

log="/home/ubuntu/syslogs/sysscrlog/user.log"

userinfo=$(w)

echo " current users logined here are ${userinfo} at $(date) " >> "${log}"
