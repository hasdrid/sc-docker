FROM ubuntu:latest

# Update package list and install tools
RUN apt-get update && apt-get install -y \
    iputils-ping curl wget net-tools iproute2 dnsutils telnet netcat-openbsd traceroute mtr \
    vim nano git unzip tar jq \
    nmap openssl \
    mysql-client postgresql-client redis-tools \
    python3 python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the default command to keep the container running
CMD ["sleep", "infinity"]