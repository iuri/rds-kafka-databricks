#!/bin/bash
set -e

# Source the .env file
# source /kafka/connect/init/.env
set -a
source ./init/.env
set +a


# Start Kafka Connect in background
/etc/confluent/docker/run &

# Wait for Kafka Connect to be ready
echo "Waiting for Kafka Connect to be available..."
while ! curl -s http://localhost:8083/connectors; do
  sleep 5
done

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



echo "Kafka Connect is ready. Creating connectors..."

# Deploy connectors
curl -s -X POST -H "Content-Type: application/json" --data @/etc/kafka-connect/connector-configs/source-postgres.json http://localhost:8083/connectors
curl -s -X POST -H "Content-Type: application/json" --data @/etc/kafka-connect/connector-configs/sink-databricks.json http://localhost:8083/connectors

wait -n
