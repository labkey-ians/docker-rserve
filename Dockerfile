FROM r-base:3.4.3

MAINTAINER Ian Sigmon <ians@labkey.com>

RUN apt-get update \
	&& apt-get install -y telnet \
		libcairo2-dev \
		libxt-dev

RUN install.r Rserve \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds
RUN install.r Cairo

ENV RSERVE_HOME /opt/rserve

RUN addgroup --gid 1042 wg
RUN useradd -G 1042 -u 1001 rserve \
	&& mkdir ${RSERVE_HOME} \
	&& usermod -d ${RSERVE_HOME} rserve

RUN usermod -a -G 1000 rserve

COPY etc ${RSERVE_HOME}/etc

# DON'T DO THIS
RUN echo 'rserve\nrserve\n' > /opt/rserve/etc/Rserv.pwd

RUN chown -R rserve:1000 ${RSERVE_HOME}

COPY run_rserve.sh ${RSERVE_HOME}/bin/

RUN chmod -R 775 ${RSERVE_HOME}

RUN mkdir /volumes \
	&& mkdir /volumes/data \
	&& chown -R :1000 /volumes/data/
RUN mkdir /volumes/reports_temp \
	&& chown -R :1000 /volumes/reports_temp/
RUN chmod -R 775 /volumes

USER rserve

## Change username and provide PASSWORD
ENV USERNAME ${USERNAME:-rserve}

ENV PASSWORD ${PASSWORD:-rserve}

RUN mkdir ${RSERVE_HOME}/work

EXPOSE 6311

HEALTHCHECK --interval=2s --timeout=3s \
 CMD sleep 1 | \
 		telnet localhost 6311 | \
		grep -q Rsrv0103QAP1 || exit 1

CMD ["/opt/rserve/bin/run_rserve.sh"]
