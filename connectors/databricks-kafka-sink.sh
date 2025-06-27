#!/bin/bash


# Create the Databricks connector
echo "Creating Debezium Postgres connector..."

curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d "{
  \"name\": \"databricks-sink\",
  \"config\": {
      \"connector.class\": \"com.databricks.kafka.connect.DatabricksDeltaLakeSinkConnector\",
      \"topics\": \"pg.public.customer\",
      \"databricks.token\": \"${DBK_TOKEN}\",
      \"databricks.workspace.url\": \"${DBK_WORKSPACE_URL}\",
      \"databricks.cluster.id\": \"${DBK_CLUSTER_ID}\",
      \"databricks.table.name\": \"${DBK_TABLE_NAME}\",
      \"output.mode\": \"append\",
      \"checkpoint.location\": \"${DBK_LOCATION}\",
      \"fail.on.data.loss\": \"false\",
      \"value.converter\": \"org.apache.kafka.connect.json.JsonConverter\",
      \"value.converter.schemas.enable\": \"false\"
  }
}" || {
  echo "❌ Failed to create Databricks connector."
  exit 1
}

echo "🎉 Connector created successfully."