#!/bin/bash

#Copyright (C) 2015 Virtual Labs IIT Guwahati
#This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the 
#Free Software Foundation, either version 3 of the License, or (at your 
#option) any later version. This program is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY; without even the implied 
#warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See th
#e GNU General Public License for more details. You should have received
# a copy of the GNU General Public License along with this program.
# If not, see http://www.gnu.org/licenses/

#Clean the terminal screen before executing the script
clear
echo "**************************************************************"
echo " Note: This script installs and hosts the Lab in a Web Server "
echo "**************************************************************"
echo -e "\n"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " This script requires to be run with root privileges "
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "\n"
echo "Checking for root user privileges..."
echo -e "\n"
echo "Please ensure that your Package Manager (apt-get / yum etc) are not running."
echo -e "\n"

#Check for root privileges, required by the script
if [ "$(whoami)" != "root" ]; then
	echo -e "\tYou do not have root privileges."
	echo -e "\tThe script is required to be run with root privileges."
	echo -e "\n"
	exit
else
	echo -e "\tYou have root privileges. Running script with root privileges..."
	echo -e "\n"
	unset all_proxy
	unset ftp_proxy
	unset http_proxy
	unset https_proxy
fi

INTERNET_ACCESS=0;

while [ $INTERNET_ACCESS -eq 0 ]
do
	echo "+++++++++++++++++++++++++++++++++"
	echo " Choose your Internet Connection "
	echo "+++++++++++++++++++++++++++++++++"
	echo -e "\n"
	echo -e  "\tPlease specify how you access the Internet"
	echo -e  "\t1. I have a Direct Connection to the Internet"
	echo -e  "\t2. I have a Proxy Connection that does NOT require a Username or Password (only Proxy Server IP Address & Port Number is required)"
	echo -e  "\t3. I have a Proxy Connection that requires a Username and Password (Proxy Server IP Address, Port Number, and Proxy Credentials are required)"
	echo -e -n "\tEnter either 1, 2 or 3 : "
	read type_of_connection

	echo -e "\n"	
	echo "+++++++++++++++++++++"
	echo " Proxy Configuration "
	echo "+++++++++++++++++++++"
	echo -e "\n"
	
	proxy_ip="";
	proxy_port="";
	username="";
	password="";
	
	case $type_of_connection in
	
		1)
			#A Direct Internet Connection was choosen
			echo -e  "\tYou have choosen a Direct Internet Connection."
			echo -e "\n"
			echo -e "\tDone!"
			echo -e "\n"
		;;

		2)
			#An Internet Connection via a Proxy Server requiring no Username/Password was choosen
			echo -e  "\tYou have choosen a Proxy Connection that does not require a Username and Password."
			echo -e "\n"
			
			#Ensure that the Proxy IP Address isn't blank
			while [ "$proxy_ip" == "" ] 
			do 
				echo -e -n "\tEnter your Proxy Server (IP Address only): "
				read proxy_ip
				echo -e "\n"
			done
			
			#Ensure that the Proxy Port Number isn't blank
			while [ "$proxy_port" == "" ]
			do
				echo -e -n "\tEnter your Proxy Server Port (Numeric only): "
				read proxy_port
				echo -e "\n"
			done
			
			#Set up the Proxy Server environment variables
			echo -e "\tSetting your http_proxy, https_proxy, ftp_proxy environment variables..."
			export http_proxy="http://$proxy_ip:$proxy_port/"
			export https_proxy="https://$proxy_ip:$proxy_port/"
			export ftp_proxy="ftp://$proxyserver:$proxy_port/"
			echo -e "\tDone!"
			echo -e "\n"
		;;

		3)
			#An Internet Connection via a Proxy Server requiring a Username/Password was choosen
			echo -e  "\tYou have choosen a Proxy connection that requires a Username and Password."
			echo -e "\n"
			
			#Ensure that the Proxy IP Address isn't blank
			while [ "$proxy_ip" == "" ] 
			do 
				echo -e -n "\tEnter your Proxy Server (IP Address): "
				read proxy_ip
			done
			
			#Ensure that the Proxy Port Number isn't blank
			while [ "$proxy_port" == "" ] 
			do 
				echo -e -n "\tEnter your Proxy Server Port (Numeric): "
				read proxy_port
			done
			
			#Ensure that the Username isn't blank
			while [ "$username" == "" ] 
			do 
				echo -e -n "\tEnter your Proxy Username: "
				read username
			done
			
			#Ensure that the Password isn't blank
			while [ "$password" == "" ] 
			do 
				echo -e -n "\tEnter your Proxy Password: "
				stty -echo
				read password
				stty echo
				echo -e "\n"
			done
			
			#Set up the Proxy Server environment variables
			echo -e "\tSetting your http_proxy, https_proxy, ftp_proxy environment variables..."
			export http_proxy="http://$username:$password@$proxy_ip:$proxy_port/"
			export https_proxy="https://$username:$password@$proxy_ip:$proxy_port/"
			export ftp_proxy="ftp://$username:$password@$proxy_ip:$proxy_port/"
			echo -e "\tDone!"
			echo -e "\n"
		;;

		*)
			echo -e "\tYour choice was invalid! Please enter a proper choice from the menu below."
			echo -e "\n"
			continue
		;;
	esac

	#Test the Internet Connection choosen
	echo -e "\n"
	echo -e "\tTesting your Internet Connection..."
	echo -e "\n"

	wget http://www.google.com 2> /dev/null
	EXITCODE=$?
	
	#Check the wget return code for success/failure
	#wget returns 0 for success non-zero for failure
	if [ $EXITCODE -ne 0 ]
	then
		echo -e -n "\tUnable to connect to the Internet! Please check your connection details..."
		echo -e "\n"
	else
		INTERNET_ACCESS=1
		echo -e -n "\tWas able to connect to the Internet successfully... Congratulations!"
		rm -rf index.html
		echo -e "\n"
	fi

done

#The script is able to connect to the Internet at this point - proceed with the initialization

#Read the Operating System details
arch=$(uname -m)
kernel=$(uname -r)

#Operating System specific distribution information file locations
if [ -f /etc/lsb-release ]; then
	os=$(lsb_release -s -d)
elif [ -f /etc/debian_version ]; then
	os="Debian $(cat /etc/debian_version)"
elif [ -f /etc/redhat-release ]; then
	os=`cat /etc/redhat-release`
else
	os="$(uname -s) $(uname -r)"
fi

OS=`echo $os| sed 's/"//g' | cut -d' ' -f1`

echo -e "++++++++++++++++++++++++++"
echo -e " Operating System Details "
echo -e "++++++++++++++++++++++++++"
echo -e "\n"
echo -e "\tDistribution : "$OS
echo -e "\tKernel Version : "$kernel
echo -e "\tArchitecture : "$arch
echo -e "\n"

case "$OS" in

	#If OS is ubuntu
	"Ubuntu")
			if [[ $type_of_connection -eq 1 ]]; then
				echo -e "\tUsing a direct Internet connection!"
				echo -e "\tNothing to do with Package Manager configuration files..."
				echo -e "\n"
			elif [[ $type_of_connection -eq 2 ]]; then
				echo "Simple Proxy. Changes to conf files necessary"
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to apt.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				if [ -f /etc/apt/apt.conf ]; then
					echo -e "\nBacking up the original apt.conf file"
					mv /etc/apt/apt.conf /etc/apt/apt.conf.vlabiitg.bak
					sudo tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://$proxy_ip:$proxy_port/";
Acquire::https::proxy "http://$proxy_ip:$proxy_port/";
Acquire::ftp::proxy "http://$proxy_ip:$proxy_port/";
EOF
				else
					echo -e "\nCreating the apt.conf file required by the script"
					sudo tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://$proxy_ip:$proxy_port/";
Acquire::https::proxy "http://$proxy_ip:$proxy_port/";
Acquire::ftp::proxy "http://$proxy_ip:$proxy_port/";
EOF
				fi
				echo -e "\n"
				echo -e "\tWriting to apt.conf... Done!"
				echo -e "\n"
			else #Automatically 3rd choice is chosen
				echo "Authenticated Proxy. Changes to conf files necessary"
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to apt.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				if [ -f /etc/apt/apt.conf ]; then
					echo -e "\nBacking up the original apt.conf file"
					mv /etc/apt/apt.conf /etc/apt/apt.conf.vlabiitg.bak
					sudo tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
Acquire::https::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
Acquire::ftp::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
EOF
				else
					echo -e "\nCreating the apt.conf file required by the script"
					sudo tee -a /etc/apt/apt.conf <<EOF
Acquire::http::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
Acquire::https::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
Acquire::ftp::proxy "http://$username:$password@$proxy_ip:$proxy_port/";
EOF
				fi	
					
				echo -e "\n"
				echo -e "\tWriting to apt.conf... Done!"
				echo -e "\n"

			fi
			
			
			if [ "$apt_pid" != "" ]; then
				echo -e "\tError: Package Manager running in the background."
				echo -e "\tError: Please exit the Package Manager and run the script again."
				exit
			fi
			
			#Update the default Package Manager
			apt-get update
			#Installing the aptitude Package Manager
			apt-get install -y aptitude

			echo "+++++++++++++++++++++++++"
			echo " INSTALLING DEPENDENCIES "
			echo "+++++++++++++++++++++++++"
			#Setup dependency variables
			pkg="aptitude"
			webserver="apache2"
			mediaplayer="vlc browser-plugin-vlc"
			
			echo -e "\n"
			echo -e "\tRunning Package Manager update..."
			echo -e "\n"
			$pkg update
			
			echo -e "\tInstalling webserver..."
			echo -e "\n"
			$pkg install -y $webserver
			
			echo -e "\tInstalling firefox..."
			echo -e "\n"
			$pkg install -y firefox
			
			echo -e "\tInstalling vlc player..."
			echo -e "\n"
			$pkg install $mediaplayer
			
			echo -e "\tInstalling flashplayer plugin..."
			echo -e "\n"
			
			if [ "$arch" == "i686" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
				
			elif [ "$arch" == "x86_64" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib64/mozilla/plugins/.
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
			
			fi
	;;


	#If OS is Fedora
	"Fedora")
			if [[ $type_of_connection -eq 1 ]]; then
				echo -e "\tUsing a direct Internet connection!"
				echo -e "\tNothing to do with Package Manager configuration files..."
				echo -e "\n"

			elif [[ $type_of_connection -eq 2 ]]; then
				echo "Using a Proxy Server that does not require a Username and Password. Changes to conf files necessary..."
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to yum.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e "\n"
				
				#Check if yum.conf exists
				if [ -f /etc/yum.conf ]; then
					echo -e "\nBacking up the original yum.conf file"
					cp /etc/yum.conf /etc/yum.conf.vlabiitg.bak
					echo "proxy=http://$proxy_ip:$proxy_port" >> /etc/yum.conf
					echo -e "\n"
					echo -e "\tWriting to yum.conf... Done!"
					echo -e "\n"
				else
					echo "File yum.conf not found! Please check if YUM (your Package Manager) is installed."
					exit
				fi

			elif [[ $type_of_connection -eq 3 ]]; then
				echo "Using a Proxy Server that requires a Username and Password. Changes to conf files necessary"
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to yum.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e "\n"
				
				#Check if yum.conf exists
				if [ -f /etc/yum.conf ]; then
					echo -e "\nBacking up the original yum.conf file"
					cp /etc/yum.conf /etc/yum.conf.vlabiitg.bak
					echo "proxy=http://$proxy_ip:$proxy_port" >> /etc/yum.conf
					echo "proxy_username=$username">>/etc/yum.conf
					echo "proxy_password=$password">>/etc/yum.conf
					echo -e "\n"
					echo -e "\tWriting to yum.conf... Done!"
					echo -e "\n"
				else
					echo "File yum.conf not found! Please check if YUM (your Package Manager) is installed."
					exit
				fi
			
			else
				echo -e "\tYour choice is invalid! Please enter either 1, 2 or 3 from the menu."
				exit
			fi
			
			echo "+++++++++++++++++++++++++"
			echo " INSTALLING DEPENDENCIES "
			echo "+++++++++++++++++++++++++"
			#Setup dependency variables
			pkg="yum"
			webserver="httpd"
			mediaplayer="vlc mozilla-vlc"
			
			echo -e "\n"
			echo -e "\tAdding the rpmfusion repository..."
			rpm -ivh ./dependencies/rpmfusion-free-release-stable.noarch.rpm
			
			#echo -e "\n"
			#echo -e "\tRunning Package Manager update..."
			#echo -e "\n"
			#$pkg update
			
			echo -e "\tInstalling webserver..."
			echo -e "\n"
			$pkg install -y $webserver
			service $webserver start
			
			echo -e "\tInstalling firefox..."
			echo -e "\n"
			$pkg install -y firefox
			
			echo -e "\tInstalling vlc player..."
			echo -e "\n"
			$pkg install -y $mediaplayer
			
			echo -e "\tInstalling flashplayer plugin..."
			echo -e "\n"
			
			if [ "$arch" == "i686" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
				
			elif [ "$arch" == "x86_64" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib64/mozilla/plugins/.
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
			
			fi
	;;

	"CentOS")  #If OS is CentOS
			if [[ $type_of_connection -eq 1 ]]; then
				echo -e "\tUsing a direct Internet connection!"
				echo -e "\tNothing to do with Package Manager configuration files..."
				echo -e "\n"

			elif [[ $type_of_connection -eq 2 ]]; then
				echo "Using a Proxy Server that does not require a Username and Password. Changes to conf files necessary..."
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to yum.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e "\n"
				
				#Check if yum.conf exists
				if [ -f /etc/yum.conf ]; then
					echo -e "\nBacking up the original yum.conf file"
					cp /etc/yum.conf /etc/yum.conf.vlabiitg.bak
					echo "proxy=http://$proxy_ip:$proxy_port" >> /etc/yum.conf
					echo -e "\n"
					echo -e "\tWriting to yum.conf... Done!"
					echo -e "\n"
				else
					echo "File yum.conf not found! Please check if YUM (your Package Manager) is installed."
					exit
				fi

			elif [[ $type_of_connection -eq 3 ]]; then
				echo "Using a Proxy Server that requires a Username and Password. Changes to conf files necessary"
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e " Writing your Proxy configuration to yum.conf "
				echo -e "++++++++++++++++++++++++++++++++++++++++++++++"
				echo -e "\n"
				
				#Check if yum.conf exists
				if [ -f /etc/yum.conf ]; then
					echo -e "\nBacking up the original yum.conf file"
					cp /etc/yum.conf /etc/yum.conf.vlabiitg.bak
					echo "proxy=http://$proxy_ip:$proxy_port" >> /etc/yum.conf
					echo "proxy_username=$username">>/etc/yum.conf
					echo "proxy_password=$password">>/etc/yum.conf
					echo -e "\n"
					echo -e "\tWriting to yum.conf... Done!"
					echo -e "\n"
				else
					echo "File yum.conf not found! Please check if YUM (your Package Manager) is installed."
					exit
				fi
			
			else
				echo -e "\tYour choice is invalid! Please enter either 1, 2 or 3 from the menu."
				exit
			fi
			
			echo "+++++++++++++++++++++++++"
			echo " INSTALLING DEPENDENCIES "
			echo "+++++++++++++++++++++++++"
			#Setup dependency variables
			pkg="yum"
			webserver="httpd"
			mediaplayer="vlc mozilla-vlc"
			
			echo -e "\n"
			echo -e "\tAdding the RPMforge repository..."
			if [ "$arch" == "i686" ]; then
				rpm -ivh ./dependencies/$arch/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
			elif [ "$arch" == "x86_64" ]; then
				rpm -ivh ./dependencies/$arch/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
			fi
			echo -e "\n"
			
			#echo -e "\n"
			#echo -e "\tRunning Package Manager update..."
			#echo -e "\n"
			#$pkg update
			
			echo -e "\tInstalling webserver..."
			echo -e "\n"
			$pkg install -y $webserver
			service $webserver start
			
			echo -e "\tInstalling firefox..."
			echo -e "\n"
			$pkg install -y firefox
			
			echo -e "\tInstalling vlc player..."
			echo -e "\n"
			$pkg install $mediaplayer
			
			echo -e "\tInstalling flashplayer plugin..."
			echo -e "\n"
			
			if [ "$arch" == "i686" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
				
			elif [ "$arch" == "x86_64" ]; then
			
				cp ./dependencies/$arch/libflashplayer.so /usr/lib64/mozilla/plugins/.
				cp ./dependencies/$arch/libflashplayer.so /usr/lib/mozilla/plugins/.
			
			fi
	;;

	*)
			echo -e "This Script has been currently tested only on Ubuntu 12+, Fedora 17+, CentOS 6.4+"
	;;
	
	esac

echo -e "+++++++++++++++++"
echo -e " PERFORMING MAKE "
echo -e "+++++++++++++++++"
echo -e "\n"

#Read the DocumentRoot of the WebServer
echo -e "\tTesting your Web Server DocumentRoot Path"
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
	documentroot=`grep "DocumentRoot"  /etc/apache2/sites-available/000-default.conf | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v "^#"  | sed -e "s/[[:space:]]\+/ /g" |  sed 's/"//g' | awk '{print $2}'`

elif [ -f /etc/apache2/sites-available/default-ssl.conf ]; then
	documentroot=`grep "DocumentRoot"  /etc/apache2/sites-available/default-ssl.conf | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v "^#"  | sed -e "s/[[:space:]]\+/ /g" |  sed 's/"//g' | awk '{print $2}'`


elif [ -f /etc/apache2/sites-available/default ]; then
	documentroot=`grep "DocumentRoot"  /etc/apache2/sites-available/default | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v "^#"  | sed -e "s/[[:space:]]\+/ /g" |  sed 's/"//g' | awk '{print $2}'`


elif [ -f /etc/httpd/conf/httpd.conf ]; then
	documentroot=`grep "DocumentRoot"  /etc/httpd/conf/httpd.conf  					 | sed 's/^[ \t]*//;s/[ \t]*$//' | grep -v "^#"  | sed -e "s/[[:space:]]\+/ /g" |  sed 's/"//g' | awk '{print $2}'`
else
	echo -e "\n"
	echo -e "\tProbably apache is not installed on your system..."
	echo -e "\n"
fi

echo -e "\n"
echo -e "\tYour Web Server DocumentRoot is set to: " "$documentroot"
echo -e "\n"
echo -e "\tPerforming make..."
echo -e "\n"
echo -e "\tThe current Working Directory is: " "$PWD"
echo -e "\n"

#Changing working directory to src
cd ../src/

#Make all
make all

#Change working directory to parent
cd ..

echo -e "\tCopying content to the Web DocumentRoot..."

#Get the Virtual Lab Name
vlabname=`echo ${PWD##*/}`

#Remove the existing copy (if any) of Virtual Lab from the DocumentRoot
rm -rf "$documentroot/$vlabname"

#Create a folder for the Virtual Lab within the DocumentRoot
mkdir "$documentroot/$vlabname"

#Copy the web source files
cp -r build/* "$documentroot/$vlabname/."

#Remove the existing copy from the build folder
rm -rf build/*

#Change mode of the folder
chmod -R 755 "$documentroot/$vlabname"

#Unsetting all Environment Variables Set by the script
unset all_proxy
unset ftp_proxy
unset http_proxy
unset https_proxy

#Restoring all original configuration files changed by the script
echo -e "\tRestoring your original Package Manager configuration..."
case "$OS" in
	#If OS is ubuntu
	"Ubuntu")
	mv /etc/apt/apt.conf.vlabiitg.bak  /etc/apt/apt.conf
	;;

	#If OS is Fedora
	"Fedora")
	mv /etc/yum.conf.vlabiitg.bak  /etc/yum.conf
	;;
	
	#If OS is CentOS
	"CentOS")
	mv /etc/yum.conf.vlabiitg.bak  /etc/yum.conf
	;;
esac
echo -e "\n"
echo -e "\tDone!"
echo -e "\n"

echo -e "\tStarting Firefox..."
firefox http://localhost/$vlabname
echo -e "\tDone!"
echo -e "\n"
