FROM haproxy:latest

ENV HAPROXY_USER root

RUN groupadd --system ${HAPROXY_USER} && \
  useradd --system --gid ${HAPROXY_USER} ${HAPROXY_USER} && \
  mkdir --parents /var/lib/${HAPROXY_USER} && \
  chown -R ${HAPROXY_USER}:${HAPROXY_USER} /var/lib/${HAPROXY_USER}

CMD ["haproxy", "-db", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
