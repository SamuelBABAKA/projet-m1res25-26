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

# Configuration SSH
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'Port 22' >> /etc/ssh/sshd_config

# Mot de passe root
RUN echo "root:password" | chpasswd

# Page web nginx de test
RUN echo "<h1>Conteneur Ubuntu 22.04 avec Nginx et SSH</h1>" > /var/www/html/index.html

# Exposer HTTP + SSH
EXPOSE 80 22

# Démarrage de SSH + Nginx
CMD service nginx start && /usr/sbin/sshd -D
