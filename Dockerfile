FROM docker-dev.odyssey.apps.csintra.net/node:8

ENV http_proxy=http://proxy.hedani.net:8080 \
    https_proxy=http://proxy.hedani.net:8080 \
    PHANTOMJS_CDNURL=http://cnpmjs.org/downloads

RUN (curl https://install.meteor.com/ | bash)

RUN apt-get update && apt-get install -y vim \
 && rm -rf /var/lib/apt/lists/*

ADD deps.tgz /home/node/rc/deps/
ADD rc.tgz /home/node/rc/src/
COPY libvips-8.7.0-linux-x64.tar.gz /home/node/.npm/_libvips/
COPY *.patch /home/node/rc/

RUN cd /home/node/rc/src \
 && git apply ../rc.src.patch \
 && chown -R node:node /home/node

WORKDIR /home/node/rc

USER node
CMD ["bash"]
