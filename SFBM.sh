#!/bin/bash
# Update: 05-05-2022
# Description: Update Upgrade

# Color variables 

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"

clear
echo -e "${GREEN}####################################################"
echo -e "${GREEN}#                                                  #"
echo -e "${GREEN}#${RED}              @ SUPERFUZZ BIGMUFF @               ${GREEN}#"
echo -e "${GREEN}#${RED}           NMAP/SMB/WFUZZ Info Grabber            ${GREEN}#"
echo -e "${GREEN}#                                                  #"
echo -e "${GREEN}####################################################"
echo""

echo -e "${GREEN}[+] Enter IP to scan:"
echo ""
echo -e "${RED}"
read inn
echo ""
echo -e "${GREEN}[+] Running Nmap...${NOCOLOR}"

function mk_dir() {
 ### Problem with re-writhing same directory...
mkdir $inn-Results
mkdir $inn-Results/Nmap
mkdir $inn-Results/SMB
mkdir $inn-Results/Wfuzz

}

function SFBM() {
nmap $inn -v0 -Pn -o $inn-Results/Nmap/$inn-Nmap.txt
echo -e "\n${GREEN}[+] Nmap Output Written to $inn-Results/Nmap/$inn-Nmap.txt\n"

if grep -Fq '445/tcp' $inn-Results/Nmap/$inn-Nmap.txt; then
  echo -e "\n${GREEN}[+] Grabbing SMB Shares...\n";
  smbclient -L $inn
  elif grep -Fq '80/tcp' $inn-Results/Nmap/$inn-Nmap.txt; then
  echo -e "[+] No SMB Here :(\n";

  echo -e "${GREEN}[+]Running Wfuzz...\n"
  wfuzz -c -v --hc 404 -w dsmall.txt -u http://$inn:80/FUZZ -f $inn-Results/Wfuzz/$inn-80-Wfuzz.txt
  echo -e "${GREEN}[+] Output Written to $inn-Results/Wfuzz/$inn-80-Wuzz.txt\n";

  else
  echo -e "[+] No SMB or HTTP/HTTPS Here :("
  echo ""
fi

exit

}

# Call functions

mk_dir # Need some work...
SFBM

