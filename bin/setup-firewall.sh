#!/usr/bin/zsh


zparseopts e:=ether_device
set_ip_rules() {
    dev=$1

    # show current rules
    iptables -nvL

    # drop all rules
    iptables -F
   
    # No need to forward any packets (not acting like NAT, etc...)
    # iptables -P FORWARD DROP

    # Allow incoming ssh
    iptables -A INPUT -i $dev -p tcp -d 192.168.2.44 --dport 22 -j ACCEPT

    # Allow outgoing packets
    iptables -P OUTPUT ACCEPT

    # Allow stateful connections, so TCP: SYN packets sent, will allow the corresponding 
    # server to reply with a SYN-ACK response
    iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Drop all other incoming
    iptables -A INPUT -j DROP

    # persist the changes
    iptables-save > /etc/iptables/iptables.rules

    # reload rules
    systemctl reload iptables
}
check_args(){
    eth_devs=(${(f)$(ifconfig -s | awk '{print $1}' | sed '1d' | grep -v '^lo$')})
    if [[ $#eth_devs -gt 1 ]]; then
        for dev in $eth_devs
        do
            while true; do
                echo "Would you like to install the rules to ethernet device '$dev': (y/n)?"
                read yn
                case $yn in
                    [Yy]* ) set_ip_rules $dev; break;;
                    [Nn]* ) continue 2;;
                    * ) echo "Please answer yes or no.";;
                esac
            done
        done
        exit 1
    fi 
    print "device: $eth_devs[1]"
    set_ip_rules $eth_devs[1]
}

check_args
