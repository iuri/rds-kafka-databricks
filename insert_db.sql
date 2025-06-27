
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
