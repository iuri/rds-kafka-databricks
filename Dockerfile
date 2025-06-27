FROM debezium/connect:2.7.3.Final

# Create a directory for external connector plugins
RUN mkdir -p /kafka/connectors

# Add the connector JARs (place them in ./connectors before building)
COPY connectors /connectors

# Optional: Set permissions
RUN chmod -R a+rx /connectors

# Update plugin.path in the Connect worker config
ENV CONNECT_PLUGIN_PATH="/connectors,/connectors/debezium-connector-postgres"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
