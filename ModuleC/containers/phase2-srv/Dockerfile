FROM debian:latest
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    net-tools iproute2 \
    inetutils-ping inetutils-traceroute iputils-arping \
    curl wget \
    tcpdump nmap \
    vim nano \
    dnsutils \
    ssh 

RUN apt-get install -y snmp


# Do not do this at real envs...

RUN echo "#!/bin/bash\n\
\n\
SWITCH_IP=\"192.168.20.252\"\n\
COMMUNITY=\"NM25\"\n\
\n\
echo \"Checking SNMP on \$SWITCH_IP with community '\$COMMUNITY'...\"\n\
\n\
# Perform SNMP walk\n\
snmpwalk -v2c -c \"\$COMMUNITY\" \"\$SWITCH_IP\" 1.3.6.1.2.1.1.1.0\n\
\n\
# Check the result\n\
if [ \$? -eq 0 ]; then\n\
  echo \"✅ SNMP is correctly configured!\"\n\
else\n\
  echo \"❌ SNMP check failed. Please check switch configuration.\"\n\
fi" > /check_snmp.sh
RUN chmod +x /check_snmp.sh

RUN echo "#!/bin/bash\n\
# Flush previous IPs\n\
ip addr flush dev eth0 || true\n\
\n\
# Set static IP manually\n\
ip addr add 192.168.20.10/24 dev eth0\n\
ip link set eth0 up\n\
ip route add default via 192.168.20.254\n\
\n\
# Show IP info for verification\n\
ip addr show eth0\n\
ip route show\n\
\n\
# Start whatever process was passed to the container\n\
exec \"\$@\"" > /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["bash"]
