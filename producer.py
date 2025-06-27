import os
import psycopg2

from faker import Faker
import faker_commerce

import json
from time import sleep
import datetime
import uuid

from dotenv import load_dotenv 
from pathlib import Path

load_dotenv(Path('./connectors/.env'))

print('host', os.getenv("DB_HOSTNAME"),'port', os.getenv("DB_PORT"), 'database', os.getenv("DB_NAME"), 'user', os.getenv("DB_PGUSER"))

# Database connection setup
conn = psycopg2.connect(
    host=os.getenv("DB_HOSTNAME"),
    port=os.getenv("DB_PORT"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_PGUSER"),
    password=os.getenv("DB_PASSWORD")    
)
conn.autocommit = True
cursor = conn.cursor()



global faker
faker = Faker()
faker.add_provider(faker_commerce.Provider)


# Insert functions
def insert_customer():
    customer_id = faker.random_int(min=1,max=10000)
    name = faker.name()
    email = faker.email()
    created_at = datetime.datetime.now()

    cursor.execute("""
        INSERT INTO public.customer (id, name, email, created_at)
        VALUES (%s, %s, %s, %s)
    """, (customer_id, name, email, created_at))

    print('Create user:', customer_id)
    return customer_id
    

def insert_order(customer_id):
    product = faker.ecommerce_name()
    quantity = faker.random_int(min=1,max=50)
    ordered_at = datetime.datetime.now()

    cursor.execute("""
        INSERT INTO public.orders (customer_id, product, quantity, ordered_at)
        VALUES (%s, %s, %s, %s)
    """, (customer_id, product, quantity, ordered_at))

    print('Create order:', product, customer_id)


    
# Main loop
for _ in range(20):
    customer_id = insert_customer()
    for _ in range(3):  # 3 orders per customer
        insert_order(customer_id)
        sleep(1)

print("✅ Done inserting data.")
cursor.close()
conn.close()
