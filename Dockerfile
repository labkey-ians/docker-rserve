FROM r-base:3.3.1

MAINTAINER Jordan Walker <jiwalker@usgs.gov>

ARG doi_network=false

RUN echo $doi_network

RUN if [ "${doi_network}" = true ]; then \
		/usr/bin/wget -O /usr/lib/ssl/certs/DOIRootCA.crt http://blockpage.doi.gov/images/DOIRootCA.crt && \
		ln -sf /usr/lib/ssl/certs/DOIRootCA.crt /usr/lib/ssl/certs/`openssl x509 -hash -noout -in /usr/lib/ssl/certs/DOIRootCA.crt`.0; \
	fi

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
