FROM nginx

MAINTAINER Nick Hilhorst "nick.hilhorst@kpnmail.nl"

# These environment variables are needed to run agentadmin.sh unattended on
# starting the container. You'll probably want to override them on the
# commandline.
ENV OPENAM_URL=http://openam:58080/opensso AGENT_PROFILE_NAME=NginxAgent AGENT_PASSWORD=password CONFIRM=y

# Install the OpenAM Policy Agent for NGINX by Tsukasa Hamano
# as described on https://github.com/hamano/nginx-mod-am.
RUN apt-get update && \
	apt-get install -y wget unzip libnspr4 libnss3 libxml2 libpcre3 libssl1.0.0 && \
	rm -rf /var/lib/apt/lists/*

RUN wget -P /tmp -q --no-check-certificate \
		https://www.osstech.co.jp/download/hamano/nginx/nginx_agent_20141119.deb.x86_64.zip && \
	unzip /tmp/nginx_agent_20141119.deb.x86_64.zip -d /opt && \
	rm /tmp/nginx_agent_20141119.deb.x86_64.zip

WORKDIR /opt/nginx_agent/

# With the OpenAM Policy Agent installed and the enviromnent variables set
# we can run the agentadmin.sh script and start nginx
CMD ./bin/agentadmin.sh && nginx -g "daemon off;"
