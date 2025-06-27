#!/bin/bash

# Create the Postgres connector
echo "Creating Debezium Postgres connector..."

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d "{
  \"name\": \"postgres-rds-connector\",
  \"config\": {
    \"connector.class\": \"io.debezium.connector.postgresql.PostgresConnector\",
    \"database.hostname\": \"${DB_HOSTNAME}\",
    \"database.port\": \"${DB_PORT}\",
    \"database.user\": \"${DB_USER}\",
    \"database.password\": \"${DB_PASSWORD}\",
    \"database.dbname\": \"${DB_NAME}\",
    \"database.server.name\": \"rds-postgres\",
    \"plugin.name\": \"pgoutput\",
    \"slot.name\": \"debezium_slot\",
    \"publication.name\": \"debezium_pub\",
    \"snapshot.mode\": \"initial\",
    \"table.include.list\": \"public.customer, public.orders\",
    \"topic.prefix\": \"rds-postgres\",
    \"schema.history.internal.kafka.bootstrap.servers\": \"kafka:9092\",
    \"schema.history.internal.kafka.topic\": \"schema-changes.inventory\"
  }
}" || {
  echo "❌ Failed to create Postgres connector."
  exit 1
}

echo "🎉 Connector created successfully."

