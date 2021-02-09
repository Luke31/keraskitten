FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
	libopencv-dev \
        python3-pip \
	python3-opencv && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    libjpeg-turbo-progs \
    libjpeg8-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y install \
    graphviz \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.base.txt requirements.base.txt
RUN pip3 install -r requirements.base.txt
RUN pip3 install keras==2.4.3 --no-deps

COPY requirements.additional.txt requirements.additional.txt
RUN pip3 install -r requirements.additional.txt

RUN ["mkdir", "notebooks"]
COPY conf/.jupyter /root/.jupyter
COPY run_jupyter.sh /

# Jupyter and Tensorboard ports
EXPOSE 8888 6006

# Store notebooks in this mounted directory
VOLUME /notebooks

CMD ["/run_jupyter.sh"]
