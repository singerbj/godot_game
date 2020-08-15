# Kill the database
ps -A | grep cockroach | awk '{print $1}' | xargs kill -9 $1

# Start 1st db node
cd nakama

cockroach start \
--insecure \
--store=node1 \
--listen-addr=localhost:26257 \
--http-addr=localhost:8080 \
--join=localhost:26257,localhost:26258,localhost:26259&

sleep 2

# Start 2nd db node
cockroach start \
--insecure \
--store=node2 \
--listen-addr=localhost:26258 \
--http-addr=localhost:8081 \
--join=localhost:26257,localhost:26258,localhost:26259&

sleep 2

# Start 3rd db node
cockroach start \
--insecure \
--store=node3 \
--listen-addr=localhost:26259 \
--http-addr=localhost:8082 \
--join=localhost:26257,localhost:26258,localhost:26259&

sleep 2

# init db
cockroach init --insecure --host=localhost:26257&

sleep 2

# migrate db
nakama migrate up

# start nakama
nakama 
