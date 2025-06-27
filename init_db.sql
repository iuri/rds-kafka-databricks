
---
-- DB Config settgins to DMS
---
-- CREATE ROLE dms_user WITH LOGIN PASSWORD 'your_secure_password';
-- GRANT rds_replication TO dms_user;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO dms_user;
-- CREATE PUBLICATION dms_pub FOR ALL TABLES;

---
-- DB Config settings to Debezium
---
-- CREATE ROLE debezium WITH LOGIN PASSWORD 'StrongPassword';
-- GRANT rds_replication TO debezium;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO debezium;
-- CREATE PUBLICATION debezium_pub FOR ALL TABLES; 


---
-- GRANT ACCESS TO DEBEZIUM AS A PRIVILEGED USER
--
-- GRANT USAGE ON SCHEMA public TO debezium;
-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO debezium;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO debezium; 



DROP PUBLICATION IF EXISTS debezium_pub;

-- DROP DATABASE IF EXISTS mundoticket;
-- CREATE DATABASE mundoticket;

DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.customer CASCADE;


CREATE TABLE public.customer (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Create tables in the public schema
CREATE TABLE public.orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES public.customer(id),
    product TEXT,
    quantity INT,
    ordered_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE PUBLICATION debezium_pub FOR TABLE public.customer, public.orders;


