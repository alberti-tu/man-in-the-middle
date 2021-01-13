# Man In The Middle
This repository contains a Linux shell script to redirect LAN traffic to the local machine. This is known as a Man In The Middle attack and consists of poisoning the ARP tables with false information to fool the two machines.

**IMPORTANT: This script is for educational purposes only and the owners of the affected IP addresses must authorize the redirection of traffic through their computer.**

## 1. Set up

The attack uses the arpspoof program that can be found in the dsniff package. You can use the following commands to add it on your machine.

```
sudo apt-get update
sudo apt-get install dsniff

cd man-in-the-middle/
chmod +x setup.sh
```

## 2. Start attack

Open folder and execute the shell script.

```
cd man-in-the-middle/
sudo ./setup.sh [interface] [target 1] [target 2]
```

### 2.1 Example

If we have the following network, the script needs the two IP address of end to end machines and our interface name. 

With the next command we can obtain the active interface name.

```
ip addr show | awk '/inet.*brd/{print $NF; exit}'
```

The target IP address it can be obtained by a LAN analyser or nmap package. If you don't have it, you can easily intalled with this command.

```
sudo apt-get install nmap
```

<img src="https://versprite.com/wp-content/uploads/2017/12/MiTM-Attack.png">

In this example our IP address is 10.5.0.135 and the interface name is wlan0. The targets are 10.5.0.180 and 10.5.0.190. Finally we put all this information as script arguments.

```
cd man-in-the-middle/
sudo ./setup.sh wlan0 10.5.0.180 10.5.0.190
```

NOTE 1: The order of the targets is not relevant.

NOTE 2: The IP addresses must belong to the same subnet as the attacker's computer. If you want to capture the traffic between a computer on the LAN and outbound connexions, you must specify the default gateway address as one of the targets.

Now all traffic between targets pass through our computer and can be caught by a sniffer program such as Wireshark.

## 3. Stop attack

Press Ctrl + c or close the shell window.

The targets may lose connection for a few seconds, but it recovers automatically.
