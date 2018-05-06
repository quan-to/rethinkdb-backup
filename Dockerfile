FROM rethinkdb:2.3.6
MAINTAINER Lucas Teske <lucas@contaquanto.com.br>

RUN apt update && apt install -y curl python-pip && pip install rethinkdb awscli && rm -rf /var/lib/apt/lists/*

COPY main.sh /main.sh
COPY notify.sh /notify.sh
COPY slack.json /slack.json

# For Dockerhub Automate build bug
RUN chmod +x /main.sh
RUN chmod +x /notify.sh

CMD /main.sh
