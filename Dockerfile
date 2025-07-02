FROM ubuntu:25.04

# Install dependencies
RUN apt-get update && apt-get install -y curl gnupg lsb-release postgresql postgresql-client



RUN apt-get update && apt-get install -y kea

# Create necessary directories
RUN mkdir -p /etc/kea /var/lib/kea /run/kea /var/run/kea

# Expose DHCP ports
EXPOSE 67/udp
EXPOSE 547/udp
EXPOSE 8000/tcp


RUN echo "#!/bin/bash" >> /usr/local/bin/start-kea.sh
RUN echo "kea-admin db-init pgsql -u kea -p kea -n kea -h db -p 5432" >> /usr/local/bin/start-kea.sh
RUN echo "sleep 50" >> /usr/local/bin/start-kea.sh
RUN echo "kea-dhcp4 -c /etc/kea/kea-dhcp4.conf &" >> /usr/local/bin/start-kea.sh
RUN echo "sleep 50" >> /usr/local/bin/start-kea.sh
RUN echo "kea-ctrl-agent -c /etc/kea/kea-ctrl-agent.conf &" >> /usr/local/bin/start-kea.sh
RUN echo "wait -n" >> /usr/local/bin/start-kea.sh
RUN chmod +x /usr/local/bin/start-kea.sh


CMD ["/usr/local/bin/start-kea.sh"]
