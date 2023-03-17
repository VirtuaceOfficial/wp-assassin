
clear
title="WordPress Assassin | By Virtuace Security"
echo -e "$title\n"
echo -e "Superuser Privilege Required. \n"
sudo chmod +x return.sh
clear

echo -e "$title\n"
read -p "Enter Target Domain (example.com): " target
read -p "Enter name for logfile: " logname
clear
echo -e "$title\n"

option=("WordPress Port Scan" "WordPress Vulnerability Scan" "Web Server Header Exploitation" "Web Server Vulnerability Scan" "Web Server Exploitation" "Quit")

select opt in "${option[@]}"
do
    case $opt in

        "WordPress Port Scan")
            clear
            echo -e "$title\n"
            nslookup $target| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            #read -p "Enter name for logfile: " logname
            echo -e "\nTarget Selected $target, How should I scan?\n"
                
                scanoptions=("Full TCP Port Scan" "Common TCP Ports" "SSH, FTP, and RDP Ports Only")

                select opts in "${scanoptions[@]}"
                do
                    case $opts in
                        "Full TCP Port Scan")
                        clear
                        echo -e "$title\n"
                        outputlog=("logs/full_tcp_scan-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nSelected Target: $target\nServer IP: $iptarget\nPlease be patient, this may take several minutes. \n"
                        sudo nmap -sS -A -p- -T4 -v $iptarget -oN $outputlog
                        clear
                        echo -e "$title\n"
                        echo -e "Scan Completed.\nOpen Ports Found on the server:\n"
                        cat $outputlog | grep "/tcp open"                       
                        ;;

                        "Common TCP Ports")
                        clear
                        echo -e "$title\n"
                        outputlog=("logs/common_ports-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nScanning 13 TCP Ports on $target, this may take a moment \n"
                        sudo nmap -sS -p T:21,22,23,25,53,80,443,554,3306,161,162,445,5432,179 -T4 -v $iptarget
                        echo -e "Scan Completed.\n"
                        cat $outputlog | grep "/tcp open"        
                        ;;

                        "SSH, FTP, and RDP Ports Only")
                        clear
                        echo -e "$title\n"
                        outputlog=("logs/ssh_tcp_rdp-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nScanning 13 TCP Ports on $target, this may take a moment \n"
                        sudo nmap -sS --p T:21,22,3389 -T4 -A $iptarget
                        echo -e "Scan Completed.\n"
                        cat $outputlog | grep "/tcp open"
                        sh ./return.sh
                        ;;

                    *) echo -e "Invalid Option $REPLY";;
                    esac
                done
    ;;

        "WordPress Vulnerability Scan")
            clear
            echo -e "$title\n"
            nslookup $target| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            echo -e "\nTarget Selected $target, How should I scan?\n"

            vulnscanopts=("Firewall Detection Scan" "Web Server Vulnerability Scan" "Plugin Vulnerability Analysis" "Client Side Attack Vector Vuln" "Main Menu")
            
            select opts2 in "${vulnscanopts[@]}"
            do
                case $opts2 in
                    "Firewall Detection Scan")
                    clear
                    echo -e "$title\n"
                    wafw00f $target
                    echo -e "\nPress 'Enter' to return to vulnerability menu.\n"
                ;;  
                    "Web Server Vulnerability Scan")
                    clear
                    echo -e "$title\n"
                    echo -e "\t\t\t-- WARNING --\nIT IS UNADVISED TO RUN THIS TOOL WITHOUT PROXYCHAINS ENABLED \n"
                    
                    nikto -host $target
                ;;
                    "Plugin Vulnerability Analysis")
                    clear
                    echo -e "$title\n"
                    read -p "Enter Plugin or Service Name: " plugin_name
                    read -p "Enter Plugin Port: " plugin_port
                    echo -e "\n Plugin/Service Selected: $plugin_name"
                    echo -e "\n Plugin Port: $plugin_port\n"
                ;;
                    "Client Side Attack Vector Vuln")
                    clear
                    echo -e "$title\n"
                    echo -e "Under Construction. Press Enter to go back."
                ;;
                    "Main Menu")
                    clear
                    targetkeep=("Yes, maintain $target (not working, select no)" "No, I want to select a new target")
                    select keep_target in "${targetkeep[@]}"
                    do
                        case $keep_target in
                            "Yes, maintain $target (not working, select no)")
                            echo -e "$target" >> targetsave.txt 
                            echo -e " will be maintained"
                            echo -e "\nReturning to main menu in 2 seconds..."
                            sleep 2
                            ./targethold.sh
                        ;;
                            "No, I want to select a new target")
                            echo -e "The target $target will not be maintained. Program must be restarted."
                            sleep 1
                            echo -e "Exiting WordPress Assassin"
                            #echo -e "\nReturning to main menu in 2 seconds..."
                            sleep 1
                            #./return.sh <-- Major bugfixes needed, will be implemented in the future
                            exit 0
                        ;;
                        *)
                        esac
                    done
                    
                ;;
                *)    
                esac
            done
    ;;
        "Web Server Exploitation")
            clear
            echo -e "$title\n"
            echo -e "Under Construction\n"
            sleep 1
            echo -e "Press Enter to return to main menu..."
    ;;
        "Quit")
            echo "Exiting"
            exit 0
    ;;
    *) echo "Invalid Option $REPLY";;
    esac
done
exit 0