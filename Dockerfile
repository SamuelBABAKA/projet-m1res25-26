DEPUIS ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractif

# Mise à jour + installation des paquets nécessaires
EXÉCUTER apt-get update && apt-get install -y \
nginx \
serveur openssh \
iputils-ping \
outils réseau \
nano
python3 \
sudo \
sshpass \
&& rm -rf /var/lib/apt/lists/*

# Préparation du service SSH
RUN mkdir -p /var/run/sshd && ssh-keygen -A

# Autoriser root à se connecter en SSH (utile pour Ansible)
#EXÉCUTER sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#EXÉCUTER sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
#EXÉCUTER sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
#EXÉCUTER sed -i 's/#PubKeyAuthentication yes/PubKeyAuthentication yes/' /etc/ssh/sshd_config

### config ssh_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
EXÉCUTER echo 'Port 22' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

# Exposer Apache + SSH
EXPOSE 80 22

EXÉCUTER echo "root:mot de passe" | chpasswd

# Démarrage de SSH (Apache sera lancé manuellement ou via Ansible)
CMD ["/usr/sbin/sshd", "-D"]
