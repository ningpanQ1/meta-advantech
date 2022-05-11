# meta-adv-imx
Advantech IIoT imx series yocto meta layers


# Quick Start Guide
-----------------
## 1. Host Setup
Essential Yocto Project host packages are:					
```
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
pylint3 xterm rsync curl
```

## 2. sync source and setup environment
See the Advantech Yocto Project User's Guide for instructions on installing repo.							
First install the Advantech Linux BSP repo						
```
$: repo init -u https://github.com/Advantech-IIoT/adv-imx-yocto-bsp  -b hardknott -m default.xml
```

Download the Yocto Project Layers:					
````
$: repo sync
````
								
If errors on repo init, remove the .repo directory and try repo init again.						

Advantech Linux Yocto Project Setup:
```						
$: [MACHINE=<machine>] [DISTRO=fsl-imx-<backend>] source ./imx-setup-release.sh -b <build folder>
```
					
where					
 <machine> defaults to imx8mmeamb9918a1		
 <build folder> specifies the build folder name  

After this your system will be configured to start a Yocto Project build.												
To use an existing Yocto build directory:										
```
$: source setup-environment <build path>
```
						

## 3.Build images
---------------------
Each graphical backend X11, Frame buffer and Wayland must be in a separate build directory, so the setup script above must be run for each backend to configure the build correctly. In this release two image recipes are provided that work on almost all backends.						

DISTROs are new and the way to configure for any backends.  Use DISTRO= instead of the -e on the setup script.					
The -e parameter gets converted to the appropriate distro configuration.					

***Note:***						
***DirectFB is no longer supported in i.MX graphic builds.***								
***The X11 and Framebuffer distros are only supported for i.MX 6 and i.MX 7.  i.MX 8 should use xwayland only.***						
***XWayland is the default distro for all i.MX families.***						

-   imx-image-multimedia: This image contains all the packages except QT5/OpenCV/Machine Learning packages.					
-   imx-image-full: This is the big image which includes imx-image-multimedia + OpenCV + QT5 + Machine Learning packages.					
-   swupdate-image: Advantech OTA recovery initrd image for recovery image  					

Here are some examples:																
(The example uses the imx8mmeamb9918a1 MACHINE but substitute this with whatever you are using)					
					
### 3.1 Building Frame Buffer (FB)
---------------------------
```
  DISTRO=fsl-imx-fb MACHINE=imx6qsabresd source imx-setup-release.sh -b build-fb
  bitbake <image>
```
						
To run the QT5 examples use the following parameters:				
```	
<QT5 Example> -platform eglfs -plugin evdevtouch:/dev/input/event0						
```
					
### 3.2 Building XWayland
---------------------------
```
  DISTRO=fsl-imx-xwayland MACHINE=imx6qsabresd source imx-setup-release.sh -b build-xwayland
  bitbake <image>
```
							
To run the QT5 examples use the following parameters:				
```
<QT5 example> platform wayland-egl -plugin evdevtouch:/dev/input/event0 --fullscreen
```
						
### 3.3 Building Wayland-Weston (wayland)
---------------------------
```
  DISTRO=fsl-imx-wayland MACHINE=imx6qsabresd source imx-setup-release.sh -b build-wayland
  bitbake <image>
```
						
To run the QT5 examples use the following parameters:						
```
<QT5 example> platform wayland-egl -plugin evdevtouch:/dev/input/event0 --fullscreen
```
						
### 3.4 Building with Multilib support
---------------------------
Yocto Project is able to build libraries for different target optimizations, combing those in one system image,
allowing the user to run both 32-bit and 64-bit applications.					
Here is an example to add multilib support (lib32).						

In local.conf											
- Define multilib targets		
```										
require conf/multilib.conf									
MULTILIBS = "multilib:lib32"												
DEFAULTTUNE_virtclass-multilib-lib32 = "armv7athf-neon"												
```
												
- 32-bit libraries to be added into the image
```						
IMAGE_INSTALL_append = " lib32-glibc lib32-libgcc lib32-libstdc++"											
```
						
### 3.5 Hardware Floating Point
-----------------------
This release enables hardware floating point by default.  This feature is enabled in both the machine 
configurations and in the layer.conf. (Some machine files exist in the community meta-fsl-arm without this setting.)						
```
DEFAULTTUNE_mx6 = "cortexa9hf-neon
```
						
Software floating point is not supported starting with the 4.1.15_1.0.0_ga release						

### 3.6 Restricted Codecs
-----------------
These codecs have contractual restrictions that require separate distribution.						

### 3.7 The Manufacturing Tool - MFGTool
--------------------------------
In this release MFGTool uses the community setup.						
To build MFGTool, build the following:					
```
   bitbake fsl-image-mfgtool-initramfs
```
						
## 4. End User License Agreement
--------------------------
During the NXP Yocto Project Community BSP setup-environment process, the NXP i.MX End User License Agreement (EULA)
is displayed. To continue, users must agree to the conditions of this license. The agreement to the terms allows the
Yocto build to untar packages from the NXP mirror. Please read this license agreement carefully during the
setup process because, once accepted, all further work in the Yocto environment is tied to this accepted agreement.

## 5. Chromium
---------
Add Chromium to your Wayland or X11-based image by adding the following lines to local.conf:						
```
IMAGE_INSTALL_append = \						
    "${@bb.utils.contains('DISTRO_FEATURES', 'wayland', ' chromium-ozone-wayland', \						
        bb.utils.contains('DISTRO_FEATURES',     'x11', ' chromium-x11', \						
                                                        '', d), d)}"						
```
												
Build server host requirements for chromium 74 version:						

- Host gcc version should be gcc 7. Ubuntu 18.04 has a default gcc 7 version.						
- Increase ulimit (number of open file descriptors) to 4098						
						
Chromium will have compilation errors, if any of the above host requirements are not met.						
						
## 6. QTWebEngine
--------
Qtwebengine is not built by default so add this to local.conf or image recipe. It is supported only on the machines
that has GPU.
```						
 IMAGE_INSTALL_append = "packagegroup-qt5-webengine"						
```
												
There are many browsers available using QtWebEngine and can be found here:						
/usr/share/examples/webengine						
/usr/share/examples/webenginewidgets						
							
## 7. Qt
----------------
Note that Qt has both a commercial and open source license options.  Make the decision about which license
to use before starting work on custom Qt applications.  Once custom Qt applications are started with an open source
Qt license the work cannot be used with a commercial Qt license.  Work with a legal representative to understand
the differences between each license.						
						
Note Qt is not supported on i.MX 6UltraLite and i.MX 7Dual. It works on X11 backend only but is not a supported feature.						
						
### 7.1 Qt with kms
----------------------
Some customers wants to use QT without wayland/weston and the alternative for that is to use through kms plugin.						
This configuration is supported only on mx8 machines.						
By default, wayland plugin is enabled.We can switch to kms plugin by following these steps.						
- killall weston						
- export QT_QPA_EGLFS_ALWAYS_SET_MODE=1						
- Run any qt application using -platform eglfs		
										
  Example:
```
 ./Qt5_CinematicExperience -platform eglfs						
```
													
## 8. Systemd
--------------
Systemd support is enabled as default but it can be disabled by commenting out the systemd settings in
meta-sdk/conf/distro/include/fsl-imx-preferred-env.inc.					
							
## 9. Build the SDK Installer
To build the SDK installer for a standard SDK and populate the SDK image, use the following command form. Be sure to replace image with an image (e.g. “imx-image-full”):						
```
  $ bitbake image -c populate_sdk	
```							
You can do the same for the extensible SDK using this command form:						
```
  $ bitbake image -c populate_sdk_ext
```					
