FROM ubuntu AS RUNTIME

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /config

COPY . .

RUN chmod -R +x /config/*.sh 

CMD ["/bin/bash", "/config/setup_env.sh"]