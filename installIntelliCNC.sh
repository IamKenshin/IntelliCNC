#!/bin/bash

# IntelliCNC installation script

rtaiKernel="3.4-9-rtai-686-pae"
actualKernel=`uname -r`
installDir="intellicnc-dev"

if [ "$actualKernel" != "$rtaiKernel" ]; then	# Install RTAI
	echo "${0}--> RTAI kernel is not installed (expected: ${rtaiKernel}, got: ${actualKernel}), installing ${rtaiKernel}..."

	sudo /usr/bin/apt-key adv --keyserver hkp://keys.gnupg.net --recv-key 3cb9fd148f374fef
	echo "${0}--> Added LinuxCNC archive signing key"

	sudo /usr/bin/add-apt-repository "deb http://linuxcnc.org/ precise base 2.7-rtai"
	echo "${0}--> Added LinuxCNC APT source"
	sudo /usr/bin/apt-get update

	sudo /usr/bin/apt-get -y install linux-image-3.4-9-rtai-686-pae rtai-modules-3.4-9-rtai-686-pae
	echo "${0}--> Installed RTAI kernel + modules"

	sudo /usr/bin/apt-get -y install linux-headers-3.4-9-rtai-686-pae
	echo "${0}--> Installed Linux kernel headers"

	echo "${0}--> RTAI installation complete, reboot the system, then run this script again"
	
else
	echo "${0}--> RTAI kernel: ${rtaiKernel} already installed, installing IntelliCNC..."
	
	if [ -d "$installDir" ]; then
		echo "${0}--> IntelliCNC already installed at '`pwd`/${installDir}'"
		
	else
		sudo /usr/bin/apt-get -y build-dep linuxcnc
		echo "${0}--> Installed LinuxCNC dependencies"
		
		sudo /usr/bin/apt-get -y install git
		echo "${0}--> Installed Git"
		
		/usr/bin/git clone https://github.com/IamKenshin/linuxcnc $installDir
		echo "${0}--> Cloned IntelliCNC src"
		
		cd "${installDir}/debian/"
		./configure uspace
		cd ../
		echo "${0}--> Required packages: `dpkg-checkbuilddeps`"
		sudo /usr/bin/apt-get -y install libudev-dev libxenomai-dev w3c-linkchecker bwidget libtk-img tclx
		echo "${0}--> installed more LinuxCNC dependencies"
		
		cd "src/"
		./autogen.sh
		./configure --with-realtime=uspace
		make
		echo "${0}--> Built IntelliCNC"
		
		sudo make setuid
		echo "${0}--> Configured IntelliCNC for realtime"
		
		echo "${0}--> IntelliCNC build complete."
	fi
	
	echo "${0}--> Run RIP tests? [y/n]"
	
	if [ -d "${installDir}" ]; then	# Not in install dir
		cd "${installDir}/src/"
	fi
	
	read confirm
	if [ "$confirm" == "y" -o "$confirm" == "Y" ]; then
		source ../scripts/rip-environment
		runtests
	fi	
fi		
