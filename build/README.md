# Build脚本使用说明

本文件夹下脚本，通过使用配置脚本设置环境变量，帮助您进行固件烧写img构建

## 变量配置一次摸清

此处请注意两个脚本文件： configs 文件夹下的脚本文件（固件配置） 和 Top目录下的 **env.sh**（公共环境配置）

首先来看 env.sh:

根据提示，前5个变量需要我们进行修改，分别是：

- _TOP_DIR          ---  镜像包所在的一级目录
- _KERNEL_MAINDIR   ---  主线Linux源码所在目录
- _UBOOT_DEVDIR     ---  Uboot源码所在目录
- _BR_DEVDIR        ---  Buildroot所在目录
- _CP_CMD           ---  复制命令(默认为docker拉取)

再来看configs文件夹下的脚本文件 ： **env-xxxxx.sh**

- 默认加载 env.sh 中的行动
- _SCREEN_PRAM      ---  选择屏幕大小版本（通过注释切换）（目前仅提供了480x272与800x480两种）
- _CASE_NAME        ---  各类文件的前缀名
- _BOOT_DEV         ---  默认启动设备
- _KERNEL_TYPE      ---  内核类型（主线或bsp）
- _KERNEL_VER       ---  内核版本号（menuconfig可见）
- _DT_NAME          ---  设备树名称
- _ROOTFS_TYPE      ---  自我定义
- _IMG_SIZE         ---  生成的镜像大小（越大，根文件系统剩余空间越多）
- _UBOOT_SIZE       ---  导入的Uboot大小
- _CFG_SIZEKB       ---  config文件大小（其值大小、是否为0与内核版本有关）
- _P1_SIZE          ---  给第一分区划分的大小（以 M 为单位）

> - 您若仅需烧写，修改好公共环境变量，固件配置可保持不变；
> - 您若需要编写自己的配置文件，请通过修改上述变量进行适配；

## 正确使用姿势

1. 按照上一节所述进行环境变量的配置
2. 执行以下命令

    ```bash
        cd configs
        source env-xxxxx.sh   # 生效环境变量
        cd ..                       # 返回上级目录
    ```
3. 使用 **write_all.sh /dev/sdX** (sdX修改为tf设备号)，一键对tf卡进行全套写入。
4. 或是使用 **pack_img.sh** 生成镜像文件

## 分区操作脚本

- write_all.sh        ---  为tf卡创建全套内容
- write_dd.sh         ---  以dd镜像的方式写入全套内容（规定了分区信息）（生成方式见下一节）
- write_boot.sh       ---  向tf卡dd进Uboot
- write_mkfs.sh       ---  单纯的为两个分区进行硬盘格式化
- write_p1.sh         ---  单纯的向第一分区写入设备树内核等
- write_p2.sh         ---  单纯的向第二分区写入rootfs
- clear_partion.sh    ---  擦除分区表
- write_partion.sh    ---  写入分区表
- write_swap.sh       ---  增加swap

## 镜像生成脚本

镜像生成最简单的方法是借助tf卡，手动或使用脚本向tf写入完结构，再dd出来，但手动生成较为琐碎且不灵活，所以我们在这里提供了脚本文件： **pack_img.sh** ，能够判断镜像大小是否符合启动要求，且借助loop模拟创建设备，快速高效。

使用方法： **sh pack_img.sh** 即可

生成的镜像在 Nano_pub_V1/image 目录下；

## docker环境下拉取资源到本地

当您在docker环境下已经成功构建相应的系统各组件，以下脚本可以帮助到您：

- pull_uboot.sh    ---  从docker环境中拉取UBOOT到原生环境
- pull_kernel.sh   ---  从docker环境中拉取(主线)Kernel与构建好的驱动模块到原生环境
- pull_br.sh       ---  从docker环境中拉取rootfs与配置文件到原生环境
