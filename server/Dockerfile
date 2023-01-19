FROM ubuntu:22.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y vim git tmux cmake wget curl python3 python3-pip

RUN git clone https://github.com/michiguel/Ordo

CMD sleep infinity
