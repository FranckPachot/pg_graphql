
# Bulding the extension with PostgreSQL 11 in the same environment as YugabyteDB

FROM yugabytedb/yugabyte:2.11.2.0-b89 as build-pg_graphql

# postgresql11-devel

RUN yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
    && yum install -y centos-release-scl &&  yum-config-manager --enable rhel-server-rhscl-7-rpms \
    && yum update -y \
    && yum install -y git gcc gcc-c++ bison flex cmake llvm-toolset-7.0 postgresql11-devel 

ENV PATH="/usr/pgsql-11/bin:${PATH}"

# libgraphqlparser

RUN export \
      VERSION="v0.7.0" \
      REPO_URL="https://github.com/graphql/libgraphqlparser" \
    && git clone -b "${VERSION}" --depth 1 "${REPO_URL}" \
    && cd libgraphqlparser \
    && cmake . \
    && make install

# pg_graphql

WORKDIR /var/tmp
RUN git clone https://github.com/supabase/pg_graphql.git
WORKDIR /var/tmp/pg_graphql

# In PG1 "too few arguments to function 'CreateTemplateTupleDesc"
RUN sed -e '/CreateTemplateTupleDesc/s/);/,false);/' -i ./src/c/lib.c 

RUN ./bin/pgc build
RUN make install

# In PG1 there's no MATERIALIZE in CTE but it is the defaut
RUN sed -e '/with .* as materialized/s/materialized//' -i /usr/pgsql-11/share/extension/pg_graphql--0.1.0.sql

# this builds a YugabyteDB container with the exension files (.control and .sql in libdir/extension and .so in pkglibdir)

FROM yugabytedb/yugabyte:2.11.2.0-b89 as main
COPY --from=build-pg_graphql ["/usr/local/lib/libgraphqlparser.so", "/tmp/pg_pkglibdir/libgraphqlparser.so"]
RUN cp /tmp/pg_pkglibdir/libgraphqlparser.so  $(/home/yugabyte/postgres/bin/pg_config --pkglibdir)
COPY --from=build-pg_graphql ["/usr/pgsql-11/lib", "/tmp/pg_pkglibdir"]
RUN cp /tmp/pg_pkglibdir/pg_graphql*          $(/home/yugabyte/postgres/bin/pg_config --pkglibdir)
COPY --from=build-pg_graphql ["/usr/pgsql-11/share/extension", "/tmp/pg_sharedir_extension"]
RUN cp /tmp/pg_sharedir_extension/pg_graphql* $(/home/yugabyte/postgres/bin/pg_config --sharedir)/extension


