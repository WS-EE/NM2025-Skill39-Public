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

RUN apt-get install -y bind9

RUN printf '#!/bin/bash\n\
ip addr flush dev eth0 || true\n\
ip addr add 192.168.10.5/24 dev eth0\n\
ip link set eth0 up\n\
ip route add default via 192.168.10.1\n\
ip addr show eth0\n\
ip route show\n\
named -u bind -g &\n\
exec "$@"\n' > /start.sh && chmod +x /start.sh

COPY bind/ /etc/bind/

EXPOSE 53/udp 53/tcp
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
CMD ["bash"]
#a