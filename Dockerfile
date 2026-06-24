FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Mise à jour + installation des paquets nécessaires
RUN apt-get update && apt-get install -y \
    nginx \
    openssh-server \
    iputils-ping \
    net-tools \
    nano \
    python3 \
    sudo \
    sshpass \
    && rm -rf /var/lib/apt/lists/*

# Préparation du service SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Autoriser root à se connecter en SSH
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config

# Définir le mot de passe root
RUN echo "root:password" | chpasswd

# Page web nginx
COPY website /var/www/html

# Exposer HTTP + SSH
EXPOSE 80 22

# Démarrage de SSH + Nginx
CMD service nginx start && /usr/sbin/sshd -D
