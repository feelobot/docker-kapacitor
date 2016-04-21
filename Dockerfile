FROM debian:jessie

ENV INFLUXDB_URL http://influx-udp.default.svc.cluster.local:8086
ENV DEBIAN_FRONTEND noninteractive
ENV KAPACITOR_VERSION 0.12.0-1

RUN apt-get update && \
	apt-get install -y wget vim curl && \
	wget -O kapacitor_${KAPACITOR_VERSION}_amd64.deb http://s3.amazonaws.com/kapacitor/kapacitor_${KAPACITOR_VERSION}_amd64.deb && \
	dpkg -i kapacitor_${KAPACITOR_VERSION}_amd64.deb && rm kapacitor_${KAPACITOR_VERSION}_amd64.deb && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY kapacitor.conf /etc/kapacitor/kapacitor.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh
COPY ticks/ /etc/kapacitor/ticks/

EXPOSE 9092
VOLUME ["/data", "/etc/kapacitor"]

CMD [ "/run.sh" ]
