
clear
echo -e "Superuser Privilege Required. \n"
sudo chmod +x return.sh
clear


option=("WordPress Port Scan" "WordPress Vulnerability Scan" "Web Server Header Exploitation" "Web Server Vulnerability Scan" "Web Server Directory Attacks" "Quit")

select opt in "${option[@]}"
do
    case $opt in

        "WordPress Port Scan")
            clear
            read -p "Enter Target Domain (example.com): " target
            nslookup $target| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            read -p "Enter name for logfile: " logname
            echo -e "\nTarget Set, How should I scan?\n"
                
                scanoptions=("Full TCP Port Scan" "Common TCP Ports" "SSH, FTP, and RDP Ports Only")

                select opts in "${scanoptions[@]}"
                do
                    case $opts in
                        "Full TCP Port Scan")
                        clear
                        outputlog=("logs/full_tcp_scan-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nSelected Target: $target\nServer IP: $iptarget\nPlease be patient, this may take several minutes. \n"
                        sudo nmap -sS -A -p- -T4 -v $iptarget -oN $outputlog
                        clear
                        echo -e "Scan Completed.\nOpen Ports Found on the server:\n"
                        cat $outputlog | grep "/tcp open"
                        
                        ;;

                        "Common TCP Ports")
                        clear
                        outputlog=("logs/common_ports-$target-$logname.txt")
                        echo -e "Full TCP Port Scan Selected.\n Output file will be saved to $outputlog"
                        echo -e "\nScanning 13 TCP Ports on $target, this may take a moment \n"
                        sudo nmap -sS -p T:21,22,23,25,53,80,443,554,3306,161,162,445,5432,179 -T4 -A $iptarget
                        echo -e "Scan Completed.\n"
                        cat $outputlog | grep "/tcp open"
                        sh ./return.sh
                        ;;

                        "SSH, FTP, and RDP Ports Only")
                        clear
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
            read -p "Enter Target Domain (example.com): " target2
            nslookup $target2| grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | awk '{print $NF}' | sed '1,2d' > iptarget.txt
            iptarget=$(cat iptarget.txt)
            read -p "Enter name for logfile: " logname
            echo -e "\nTarget Set, How should I scan?\n"

            vulnscanopts=("Firewall Detection Scan" "Web Server Vulnerability Scan" "Plugin Vulnerability Analysis" "Client Side Attack Vector Vuln" "Main Menu")
            
            select opts2 in "${vulnscanopts[@]}"
            do
                case $opts2 in
                    "Firewall Detection Scan")
                    clear
                    wafw00f $target2
                    sh ./return.sh

                ;;
                *)    
                esac
            done
    ;;
        "Web Server Header Exploitation")
            clear

    ;;
        "Quit")
            echo "Exiting"
            exit 0
    ;;
    *) echo "Invalid Option $REPLY";;
    esac
done
exit 0
