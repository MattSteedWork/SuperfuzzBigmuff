#!/bin/bash
clear
echo -e "\e[32;1m####################################################"
echo -e "\e[32;1m#                                                  #"
echo -e "\e[32;1m#\e[31;1m              @ SUPERFUZZ BIGMUFF @               \e[32;1m#"
echo -e "\e[32;1m#\e[31;1m           NMAP/SMB/WFUZZ Info Grabber            \e[32;1m#"
echo -e "\e[32;1m#                                                  #"
echo -e "\e[32;1m####################################################"
echo""

echo -e "\e[32;1m[+] Enter IP to scan:"
echo ""
echo -e "\e[31;1m"
read inn
echo ""
echo -e "\e[32;1m[+] Running Nmap..."
function map(){
mkdir $inn-Results
mkdir $inn-Results/Nmap
mkdir $inn-Results/SMB
mkdir $inn-Results/Wfuzz
nmap $inn -v0 -Pn -o $inn-Results/Nmap/$inn-Nmap.txt
echo -e "\n\e[32;1m[+] Nmap Output Written to $inn-Results/Nmap/$inn-Nmap.txt\n"
if grep -Fq '445/tcp' $inn-Results/Nmap/$inn-Nmap.txt; then
  echo -e "\n\e[32;1m[+] Grabbing SMB Shares...\n";
  smbclient -L $inn
elif grep -Fq '80/tcp' $inn-Results/Nmap/$inn-Nmap.txt; then
  echo -e "[+] No SMB Here :(\n";
  echo -e "\e[32;1m[+]Running Wfuzz...\n"
  wfuzz -c -v --hc 404 -w dsmall.txt -u http://$inn:80/FUZZ -f $inn-Results/Wfuzz/$inn-80-Wfuzz.txt
  echo -e "\e[32;1m[+] Output Written to $inn-Results/Wfuzz/$inn-80-Wuzz.txt\n";
else
  echo -e "[+] No SMB or HTTP/HTTPS Here :("
  echo ""
fi
exit
}
map

