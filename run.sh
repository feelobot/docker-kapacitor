#!/bin/bash
CONFIG_FILE="/etc/kapacitor/kapacitor.conf"
sed -i 's@INFLUXDB_URL@'$INFLUXDB_URL'@' ${CONFIG_FILE}
sed -i 's@KAPACITOR_URL@'$KAPACITOR_URL'@' ${CONFIG_FILE}
if [ -n "${SLACK_ENABLED}" ]; then
  sed -i 's@SLACK_ENABLED@'$SLACK_ENABLED'@' ${CONFIG_FILE}
  sed -i 's@SLACK_URL@'$SLACK_URL'@' ${CONFIG_FILE}
  sed -i 's@SLACK_CHANNEL@'$SLACK_CHANNEL'@' ${CONFIG_FILE}
else
  sed -i 's@SLACK_ENABLED@'false'@' ${CONFIG_FILE}
fi
echo -n 'Waiting for InfluxDB API'
while ! (ret=$(curl -I -s "$INFLUXDB_URL/ping" -o /dev/null -w "%{http_code}"); [ $ret -eq 204 ]) do 
	echo -n '.' 
	sleep 3s
done
echo '\nInfluxDB API Ready'
kapacitord -hostname $HOSTNAME -config /etc/kapacitor/kapacitor.conf
