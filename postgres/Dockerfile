# https://docs.docker.com/examples/postgresql_service/ にあるサンプルの Dockerfile です

FROM postgres:13-alpine

ENV  POSTGRES_USER=postgres
ENV  POSTGRES_PASSWORD=postgres

# RUN systemctl start postgres
# RUN psql -h localhost -p 5432 -U postgres
# RUN psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" 
# RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432:5432

# VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
# CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
COPY . /usr/local/postgres/
