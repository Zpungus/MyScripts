#!/bin/bash

#Create a random port in the 10000-20000 range
port=$((RANDOM % (10000 - 20000 + 1) + MIN))

# Function to show existing tunnels
show_tunnels () {
	echo "Existing Tunnels:"
	ps -elf | grep -E "\-L|\-R|\-D" | grep ssh | awk '{ print "PID:" $4 " " $18 " " $19 }'	
	
}

#Prompt user to select an option
echo -e "Select Option:\n 1. Create Local Tunnel\n 2. Create Remote Tunnel\n 3. Create Dynamic Tunnel\n 4. Show Existing Tunnels\n 5. Tear Down Specific Tunnel\n 6. Tear Down All Tunnels"

#Get response from user and assign to $tun variable
read tun

#If Local tunnel is selected, execute the following:
if [ $tun -eq 1 ]; then
	echo "Creating Local Tunnel"

	# User enters user@hostname and it is assigned to the $host variable
	echo "Enter user@ip"
	read host

	# User enters Host to target, assigned to $thost variable
	echo "Enter target Host"
	read thost

	# User enters Port to Target, assigned to $tport variable
	echo "Enter Target Port (22,23,80,.etc)"
	read tport

	# Use SSH to open tunnel with the parameters input by the user. 
	ssh -f $host -L $port:$thost:$tport -NT 
	sleep 1
	
	#Use ps and grep/awk to extract tunnel PID and print to console
	echo -e "\n\n\n\nTunnel PID:"
	ps -elf | grep $port | grep ssh | awk '{print $4 }'
	
	#Print port to console
	echo -e "Your Local Tunnel Port is: $port \n"
	show_tunnels

# If Remote is selected, do the following:
elif [ $tun -eq 2 ]; then
	echo "Creating Remote Tunnel"
	echo "Enter user@ip for host to create port on"
	read rhost
	echo "Enter Host IP with port to target (Generally localhost)"
	read rthost
	echo "Enter Target Port"
	read rtport
	ssh -f $rhost -R $port:$rthost:$rtport -NT 
	sleep 1
	echo -e "\n\n\n\nTunnel PID:"
	ps -elf | grep $port | grep ssh | awk '{print $4 }'
	echo -e "Your Remote Tunnel Port is: $port \n"
	show_tunnels

# If Dynamic is selected, do the following:
elif [ $tun -eq 3 ]; then
	echo "Creating Dynamic Tunnel"
	echo "Enter user@ip for target host"
	read dhost
	ssh -f $dhost -D 9050 -NT
	sleep 1
	echo -e "\n\n\n\nTunnel PID:"
	ps -elf | grep $port | grep ssh | awk '{print $4 }'
	echo -e "Your Dynamic Tunnel Port is: $port \n"
	show_tunnels
# If Show tunnels is selected, call the `show_tunnels` function. 
elif [ $tun -eq 4 ]; then
	show_tunnels

# If Tear down specific tunnel is selected, do the following:
elif [ $tun -eq 5 ]; then
	echo "Which tunnel do you wish to tear down?"
	show_tunnels
	sleep 1
	echo "Enter the PID of the tunnel you wish to tear down:"
	read kpid
	echo "Are you sure you want to tear down tunnel $kpid? (Y/N)"
	read kans
	if [ $kans == "Y" ]; then
		kill -9 $kpid
	else 
		echo "Tunnel Teardown Aborted"
	fi
	
	sleep 1
	echo -e "Tunnel $kpid torn down.\n"
	show_tunnels
# If Tear down all tunnels is selected, do the following:
elif [ $tun -eq 6 ]; then
	echo "Are you sure you want to kill all SSH tunnels? (KILLS ALL SSH SESSIONS!) (Y/N)"
	read ans
	if [ $ans == "Y" ]; then
		sudo pkill ssh	
	else
		echo "Tunnel Kill Aborted"
	fi
fi

