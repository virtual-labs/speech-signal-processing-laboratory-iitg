
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

#Assigning Executable Rights to the client and server scripts
chmod +x initialize-server.sh initialize-client.sh

OPTION_CHOSEN=99

echo "+++++++++++++++++++++++++"
echo " Welcome to Virtual labs "
echo "+++++++++++++++++++++++++"
echo -e "\n"

while [ $OPTION_CHOSEN -ne 1 ] || [ $OPTION_CHOSEN -ne 2 ] || [ $OPTION_CHOSEN -ne 3 ]
do
	echo -e  "\tPlease specify your choice"
	echo -e "\n"
	echo -e  "\t\t1. Initialize Server"
	echo -e "\n"
	echo -e  "\t\t2. Initialize Client"
	echo -e "\n"
	echo -e "\t\t3. Stop lab"
	echo -e "\n"
	echo -e  "\t\t4. Exit"
	echo -e "\n"
	echo -e -n "\tEnter either 1, 2 or 3: "
	read OPTION_CHOSEN

	case $OPTION_CHOSEN in
	
		1)
			echo -e  "\nYou have choosen to Initialize Server."
			echo -e "\nInitiazing Server..."
			bash initialize-server.sh
			echo -e "Done!"
			echo -e "\n"
			exit
		;;

		2)
			
			echo -e  "\nYou have choosen to Initialize Client."
			echo -e "\nInitiazing Client..."
			bash initialize-client.sh
			echo -e "Done!"
			echo -e "\n"
			exit
		;;

		3)
			
			echo -e "\nYou have choosen to Stop the lab."
			bash stop.sh
			echo -e "\n"
			exit
		;;

		4)
			
			echo -e "\nYou have choosen to Exit the Script."
			echo -e "\nHave a good day!"
			echo -e "\n"
			exit
		;;

		*)
			echo -e "\nYour choice was invalid! Please enter a proper choice from the menu below."
			echo -e "\n"
			continue
		;;
	esac
done
