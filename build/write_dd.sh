#!/bin/bash
sudo dd if=$_IMG_FILE of=$1 bs=64K
sync
