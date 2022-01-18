FROM grafana/grafana:latest
ADD conf/provisioning/datasources/conf.yaml /etc/grafana/provisioning/datasources
ADD conf/provisioning/dashboards/conf.yaml /etc/grafana/provisioning/dashboards
ADD conf/provisioning/grafana.ini /etc/grafana/
COPY ./dashboards/DevOps /var/lib/grafana/dashboards/DevOps
EXPOSE 3000