#!/bin/bash
$_CP_CMD $_BR_DEVDIR/output/images/rootfs.tar rootfs.tar
gzip rootfs.tar
mv rootfs.tar.gz $_ROOTFS_FILE
echo $_CP_CMD $_BR_DEVDIR/\.config $_ROOTFS_CFGFILE
$_CP_CMD $_BR_DEVDIR/\.config $_ROOTFS_CFGFILE
