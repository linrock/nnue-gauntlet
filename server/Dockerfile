FROM ubuntu:22.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC \
  apt install -y vim git tmux cmake wget curl ruby python3 python3-pip
RUN pip3 install fastapi python-multipart uvicorn
RUN gem install colorize terminal-table

RUN mkdir /gauntlet
WORKDIR /gauntlet

RUN git clone https://github.com/michiguel/Ordo
RUN cd Ordo && make && ln -s /gauntlet/Ordo/ordo /usr/local/bin/

COPY ordo_calc.sh ordo_calc_all.sh symlink_nn.sh summarize_ordo.rb .
COPY api.py .

EXPOSE $PORT
ENV PORT $PORT
CMD uvicorn api:app --host 0.0.0.0 --port ${PORT} --workers 1
