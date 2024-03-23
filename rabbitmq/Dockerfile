# Use the official RabbitMQ image with management plugins enabled
FROM rabbitmq:3-management
# Enable the Prometheus plugin
RUN rabbitmq-plugins enable --offline rabbitmq_prometheus

# Copy the entrypoint script into the image and make it executable
COPY entrypoint.sh /entrypoint.sh
COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
RUN chmod +x /entrypoint.sh

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]