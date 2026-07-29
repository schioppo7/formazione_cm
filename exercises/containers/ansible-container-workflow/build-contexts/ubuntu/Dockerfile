FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y openssh-server sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -G sudo genericuser \
    && echo "genericuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /var/run/sshd /home/genericuser/.ssh \
    && chmod 700 /home/genericuser/.ssh \
    && sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && echo 'AllowUsers genericuser' >> /etc/ssh/sshd_config

COPY id_key_genericuser.pub /home/genericuser/.ssh/authorized_keys
RUN chown -R genericuser:genericuser /home/genericuser/.ssh \
    && chmod 600 /home/genericuser/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
