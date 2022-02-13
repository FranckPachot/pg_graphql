
# build the yugabytedb container with pg_graphql extension
docker build -t yugabytedb:pg_graphql . 

# verification that all files are there:
docker run --rm yugabytedb:pg_graphql find /home/yugabyte/postgres -name '*graphql*' -ls

# test the extension creation YugabyteDB

docker run --rm yugabytedb:pg_graphql bash -c '
yugabyted start
sleep 5
ysqlsh -h $(hostname) \
 -c "select version()" \
 -c "create extension pg_graphql cascade"
'

exit

# build the yugabytedb container with pg_graphql extension
docker build -t yugabytedb:pg_graphql . 

# verification that all files are there:
docker run --rm yugabytedb:pg_graphql find /home/yugabyte/postgres -name '*graphql*' -ls

# test the extension creation in postgres

exit

# test the extension creation
docker run --rm yugabytedb:pg_graphql bash -c '
yugabyted start
sleep 5
ysqlsh -h $(hostname) \
 -c "select version()" \
 -c "create extension pg_graphql cascade"
'


