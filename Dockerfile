FROM rethinkdb:2.3.6
MAINTAINER Lucas Teske <lucas@contaquanto.com.br>

RUN apt update && apt install -y curl python-pip && pip install rethinkdb awscli && rm -rf /var/lib/apt/lists/*

COPY main.sh /main.sh

# For Dockerhub Automate build bug
RUN chmod +x /main.sh

CMD /main.sh
