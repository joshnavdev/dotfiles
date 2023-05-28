FROM ubuntu:22.04

RUN apt-get update && apt-get -y install sudo

RUN useradd -ms /bin/bash myuser
RUN echo "myuser:carlospunk" | chpasswd
RUN usermod -aG sudo myuser

USER myuser

RUN echo "carlospunk" | sudo -S apt-get install git --yes >> /dev/null

# WORKDIR /home/myuser

# RUN git clone https://github.com/joshnavdev/dotfiles.git

WORKDIR /home/myuser/dotfiles
COPY --chown=myuser:myuser . .
RUN rm -rf .zshrc
