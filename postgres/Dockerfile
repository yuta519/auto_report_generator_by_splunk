FROM postgres:13-alpine

ENV  POSTGRES_USER=postgres
ENV  POSTGRES_PASSWORD=postgres
ENV  POSTGRES_DB=agrex

EXPOSE 5432:5432
COPY ./parse_trafficlogs.sh /usr/local/postgres/
COPY ./trafficlogs.csv /usr/local/postgres/
