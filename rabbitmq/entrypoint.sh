#!/bin/bash
RABBITMQ_PID_FILE=/var/run/rabbitmq.pid rabbitmq-server -detached 
# Wait for RabbitMQ server to start
rabbitmqctl wait /var/run/rabbitmq.pid
# Add users and set permissions
rabbitmqctl add_user admin "$ADMIN_PASSWORD"
rabbitmqctl set_user_tags admin administrator

rabbitmqctl add_user server "$SERVER_PASSWORD"
rabbitmqctl add_user worker "$WORKER_PASSWORD"


rabbitmqctl set_permissions -p / server ".*" ".*" ".*"
rabbitmqctl set_permissions -p / worker ".*" ".*" ".*"
# Stop the server for a clean state
rabbitmqctl stop

# Wait for RabbitMQ to fully stop
while [ -e /var/run/rabbitmq.pid ]; do
  echo "Waiting for RabbitMQ to shut down..."
  sleep 1
done

echo "RabbitMQ has stopped."

# Start RabbitMQ server in the foreground
exec rabbitmq-server
