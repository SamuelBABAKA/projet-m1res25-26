FROM nginx:latest

RUN apt-get update -y && apt-get install -y \
    openssh-server \
    iputils-ping \
    net-tools \
    nano \
    python3 \
    sudo \
    sshpass \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd && ssh-keygen -A

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config

RUN echo "root:password" | chpasswd

RUN echo "<h1>Image Docker Nginx + SSH construite avec Jenkins</h1>" > /usr/share/nginx/html/index.html

EXPOSE 80 22

CMD service ssh start && nginx -g "daemon off;"
