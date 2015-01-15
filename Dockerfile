FROM r-base

MAINTAINER Jordan Walker <jiwalker@usgs.gov>

RUN install.r Rserve \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

ENV RSERVE_HOME /opt/rserve

RUN useradd rserve \
	&& mkdir ${RSERVE_HOME} \
	&& usermod -d ${RSERVE_HOME} rserve


COPY etc ${RSERVE_HOME}/etc
COPY run_rserve.sh ${RSERVE_HOME}/bin/

RUN chmod 755 ${RSERVE_HOME}/bin/run_rserve.sh

RUN chown -R rserve:rserve ${RSERVE_HOME}
USER rserve 

## Change username and provice PASSWORD
ENV USERNAME rserve

RUN mkdir ${RSERVE_HOME}/work

EXPOSE 6311

CMD ["/opt/rserve/bin/run_rserve.sh"]
