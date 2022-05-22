#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e """
${RED}
KKKKKKKKK    KKKKKKK     OOOOOOOOO     LLLLLLLLLLL             NNNNNNNN        NNNNNNNN
K:::::::K    K:::::K   OO:::::::::OO   L:::::::::L             N:::::::N       N::::::N
K:::::::K    K:::::K OO:::::::::::::OO L:::::::::L             N::::::::N      N::::::N
K:::::::K   K::::::KO:::::::OOO:::::::OLL:::::::LL             N:::::::::N     N::::::N
KK::::::K  K:::::KKKO::::::O   O::::::O  L:::::L               N::::::::::N    N::::::N
  K:::::K K:::::K   O:::::O     O:::::O  L:::::L               N:::::::::::N   N::::::N
  K::::::K:::::K    O:::::O     O:::::O  L:::::L               N:::::::N::::N  N::::::N
  K:::::::::::K     O:::::O     O:::::O  L:::::L               N::::::N N::::N N::::::N
  K:::::::::::K     O:::::O     O:::::O  L:::::L               N::::::N  N::::N:::::::N
  K::::::K:::::K    O:::::O     O:::::O  L:::::L               N::::::N   N:::::::::::N
  K:::::K K:::::K   O:::::O     O:::::O  L:::::L               N::::::N    N::::::::::N
KK::::::K  K:::::KKKO::::::O   O::::::O  L:::::L         LLLLLLN::::::N     N:::::::::N
K:::::::K   K::::::KO:::::::OOO:::::::OLL:::::::LLLLLLLLL:::::LN::::::N      N::::::::N
K:::::::K    K:::::K OO:::::::::::::OO L::::::::::::::::::::::LN::::::N       N:::::::N
K:::::::K    K:::::K   OO:::::::::OO   L::::::::::::::::::::::LN::::::N        N::::::N
KKKKKKKKK    KKKKKKK     OOOOOOOOO     LLLLLLLLLLLLLLLLLLLLLLLLNNNNNNNN         NNNNNNN
					Made by a Very Horny Oni.
${NC}

"""

echo -e "${BLUE}Give the IP range (IP/CIDR): ${NC}"
read RANGE

echo -e "${BLUE}[+] Pinging every IP in the range...${NC}"
fping -a -g $RANGE 2> /dev/null > alive_hosts.txt
echo -e "${BLUE}List of host alive created on current directory, Shikikan!. ${NC}"
echo -e "${BLUE}[+] Analyzing every active host to find current HTTP or HTTPS web. ${NC}"
echo "" > web_hosts.txt

for PORT in ':80' ':8080'; do
	while read IP;
	do
		HTTP_CODE=$(curl -L --write-out "%{http_code}\n" --output /dev/null --silent --insecure $IP$PORT)
		if [ $HTTP_CODE == "000" ]; then
			echo -e "${RED}[-] $IP$PORT: not responding ...${NC}"
		elif [ $HTTP_CODE == "200" ]; then
			echo -e "${GREEN}[HOST DISCOVERED] $IP$PORT is up ! : HTTP $HTTP_CODE ${NC}"
			echo "$IP$PORT : $HTTP_CODE" >> web_hosts.txt
		elif [ $HTTP_CODE == "301" ]; then
			echo -e "${BLUE}[HOST REDIRECTION] $IP$PORT redirected ! : HTTP $HTTP_CODE ${NC}"
			echo "$IP$PORT : $HTTP_CODE" >> web_hosts.txt
		fi
		done < alive_hosts.txt
done

echo -e "${BLUE}[+] List of web hosts created on current directory, Shikikan!. ${NC}"
