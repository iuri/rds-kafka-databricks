#!/bin/bash
set -e

# Source the .env file
source /kafka/connect/.env
echo "Waiting for Kafka Connect to be ready..."

MAX_RETRIES=10
RETRY_INTERVAL=5
RETRIES=0

while ! curl -s http://localhost:8083/connectors; do
  RETRIES=$((RETRIES + 1))
    echo "⏳ Kafka Connect not ready yet... ($RETRIES/$MAX_RETRIES)"
  if [ "$RETRIES" -ge "$MAX_RETRIES" ]; then
    echo "❌ Kafka Connect did not start in time. Exiting."
    exit 1
  fi
  sleep $RETRY_INTERVAL
done

echo "✅ Kafka Connect is ready."
# Wait for the Kafka Connect service to start
until curl -s http://localhost:8083/; do
  echo "Waiting for Kafka Connect to start..."
  sleep 5
done

# Create the Postgres connector
echo "Creating Debezium Postgres connector..."

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
  "name": "postgres-rds-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "$DB_HOSTNAME",
    "database.port": "$DB_PORT",
    "database.user": "$DB_USER",
    "database.password": "$DB_PASSWORD",
    "database.dbname": "$DB_NAME",
    "database.server.name": "rds-postgres",
    "plugin.name": "pgoutput",
    "slot.name": "debezium_slot",
    "publication.name": "debezium_pub",
    "include.schema.changes": "true",
    "snapshot.mode": "initial",
    "table.include.list": "public.customer,public.orders",
    "topic.prefix": "rds-postgres"
  }
}' || {
  echo "❌ Failed to create Postgres connector."
  exit 1
}

echo "🎉 Connector created successfully."


# if [ $? -eq 0 ]; then
#   echo "Postgres connector created successfully."
# else
#   echo "Failed to create Postgres connector."
# fi
# Wait for the connector to be created
# sleep 10
