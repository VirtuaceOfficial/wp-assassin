clear
title="WordPress Assassin | By Virtuace Security"
cat 'targetsave.txt' target
echo -e "$title\nSelected Target: $target"
clear
echo -e "$title\nSelected Target: $target"
echo -e "$target"

option=("WordPress TCP Port Scan" "WordPress Vulnerability Scan" "Web Server Discovery" "Web Server Exploitation" "Quit")

select opt in "${option[@]}"
do
    case $opt in
        # Main Menu
        "WordPress TCP Port Scan")
            clear
            echo -e "$title\nSelected Target: $target"
            nslookup $target| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            echo -e "\nTarget Selected $target, How should I scan?\n"
                
                scanoptions=("Full TCP Port Scan" "Common TCP Ports" "SSH, FTP, and RDP Ports Only")

                # TCP Scan Options
                select opts in "${scanoptions[@]}"
                do
                    case $opts in
                        "Full TCP Port Scan")
                        clear
                        echo -e "$title\nSelected Target: $target"
                        outputlog=("logs/full_tcp_scan-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nSelected Target: $target\nServer IP: $iptarget\nPlease be patient, this may take several minutes. \n"
                        sudo nmap -sS -A -p- -T4 -v $iptarget -oN $outputlog
                        clear
                        echo -e "$title\nSelected Target: $target"
                        echo -e "Scan Completed.\nOpen TCP Ports Found on the server:\n"
                        cat $outputlog | grep "/tcp open"                       
                        ;;

                        "Common TCP Ports")
                        clear
                        echo -e "$title\nSelected Target: $target"
                        outputlog=("logs/common_ports-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nScanning 13 TCP Ports on $target, this may take a moment \n"
                        sudo nmap -sS -p T:21,22,23,25,53,80,443,554,3306,161,162,445,5432,179 -T4 -v $iptarget
                        echo -e "Scan Completed.\n"
                        cat $outputlog | grep "/tcp open"        
                        ;;

                        "SSH, FTP, and RDP Ports Only")
                        clear
                        echo -e "$title\nSelected Target: $target"
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
        # Vulnerability Scans Menu
        "WordPress Vulnerability Scan")
            clear
            echo -e "$title\nSelected Target: $target"
            nslookup $target| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            echo -e "\nTarget Selected $target, How should I scan?\n"

            vulnscanopts=("Firewall Detection Scan" "Web Server Vulnerability Scan" "Plugin Vulnerability Analysis" "Client Side Attack Vector Vuln" "Main Menu")
            # Vulnerability Scans Options
            select opts2 in "${vulnscanopts[@]}"
            do
                case $opts2 in
                    "Firewall Detection Scan")
                    clear
                    echo -e "$title\nSelected Target: $target"
                    wafw00f $target
                    echo -e "\nPress 'Enter' to return to vulnerability menu.\n"
                ;;  
                    "Web Server Vulnerability Scan")
                    clear
                    echo -e "$title\nSelected Target: $target"
                    echo -e "\t\t\t-- WARNING --\nIT IS UNADVISED TO RUN THIS TOOL WITHOUT PROXYCHAINS ENABLED \n"
                    
                    nikto -host $target
                ;;
                    "Plugin Vulnerability Analysis")
                    clear
                    echo -e "$title\nSelected Target: $target"
                    read -p "Enter Plugin or Service Name: " plugin_name
                    read -p "Enter Plugin Port: " plugin_port
                    echo -e "\n Plugin/Service Selected: $plugin_name"
                    echo -e "\n Plugin Port: $plugin_port\n"
                ;;
                    "Client Side Attack Vector Vuln")
                    clear
                    echo -e "$title\nSelected Target: $target"
                    echo -e "Under Construction. Press Enter to go back."
                ;;
                    "Main Menu")
                    clear
                    targetkeep=("Yes, maintain $target as my primary target" "No, I want to select a new target")
                    select keep_target in "${targetkeep[@]}"
                    do
                        case $keep_target in
                            "Yes, maintain $target as my primary target")
                            
                        ;;
                        *)
                        esac
                    done
                ;;
                *)    
                esac
            done
    ;;
        # Web Server Discovery and Information Gathering
        "Web Server Discovery")
            clear
            echo -e "$title\nSelected Target: $target"
            
            # OSINT Menu
            webserveroptions=("Public OSINT" "Service Discovery" "Network Device Discovery" "Server Vulnerability Discovery")
            echo -e "Select An Option: \n"
            select wsdiscMenu in "${option[@]}"
            do
                case $wsdiscMenu in
                    "Public OSINT")
                    clear
                    echo -e "$title\nSelected Target: $target\n"
        
                    # Public OSINT Menu Options
                    osintOpts=("Shodan" "Google Dorking" "Social Media Scraping" "Pastebin Search" "Quit")
                    echo -e "Choose An Option: \n"
                    select pubosintMenu in "${optionp[@]}"
                    do # I hope you all are having a wonderful day!
                        case $pubosintMenu in
                            "Shodan")
                            echo -e "$title\nSelected Target: $target\n"
                            echo -e "Tool Under Construction"
                        ;;
                            "Google Dorking")
                            echo -e "$title\nSelected Target: $target\n"
                            echo -e "Tool Under Construction"
                        ;;
                            "Social Media Scraping")
                            echo -e "$title\nSelected Target: $target\n"
                            echo -e "Tool Under Construction"
                        ;;
                            "Pastebin Search")
                            echo -e "$title\nSelected Target: $target\n"
                            echo -e "Tool Under Construction"
                        ;;
                            "Quit")
                            echo -e "Exiting in 2 seconds...\n"
                            echo -e "Thank you for using WordPress Assassin\n"
                            sleep 2
                            exit 0
                        ;;
                        *)
                        esac
                    done
                    exit 0
                ;;
                    # Service Discovery Menu
                    "Service Discovery")
                    clear
                    echo -e "$title\nSelected Target: $target\n"
                    echo -e "Choose An Option \n"

                ;;
                    # Network Device Discovery
                    "Network Device Discovery")
                    clear
                    echo -e "$title\nSelected Target: $target\n"
                    echo -e "Choose An Option \n"

                ;;
                    # Server Vulnerability Discovery
                    "Server Vulnerability Discovery")
                    clear
                    echo -e "$title\nSelected Target: $target\n"
                    echo -e "Choose An Option \n"

                ;;
                *)
                esac
            done
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