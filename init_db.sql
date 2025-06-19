
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



-- Insert customers
INSERT INTO public.customer (name, email, created_at) VALUES
('Alice Johnson', 'alice@example.com', NOW() - INTERVAL '10 days'),
('Bob Smith', 'bob@example.com', NOW() - INTERVAL '8 days'),
('Charlie Lee', 'charlie@example.com', NOW() - INTERVAL '6 days');

-- Insert orders
INSERT INTO public.orders (customer_id, product, quantity, ordered_at) VALUES
(1, 'Wireless Mouse', 2, NOW() - INTERVAL '9 days'),
(1, 'Mechanical Keyboard', 1, NOW() - INTERVAL '8 days'),
(2, 'USB-C Hub', 3, NOW() - INTERVAL '7 days'),
(3, 'Monitor Stand', 1, NOW() - INTERVAL '5 days'),
(3, 'Webcam', 1, NOW() - INTERVAL '4 days');
