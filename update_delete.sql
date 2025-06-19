-- UPDATE operations

-- Update customer email
UPDATE public.customer
SET email = 'alice.johnson+updated@example.com'
WHERE name = 'Alice Johnson';

-- Update a customer's name
UPDATE public.customer
SET name = 'Robert Smith'
WHERE name = 'Bob Smith';

-- Update quantity in an order
UPDATE public.orders
SET quantity = 5
WHERE product = 'USB-C Hub' AND customer_id = 2;

-- Change product name
UPDATE public.orders
SET product = 'Ergonomic Monitor Stand'
WHERE product = 'Monitor Stand';

-- 🗑️ DELETE operations

-- Delete one order
DELETE FROM public.orders
WHERE product = 'Webcam' AND customer_id = 3;

-- Delete a customer (will require ON DELETE CASCADE or manual order cleanup)
-- First, delete dependent orders
DELETE FROM public.orders
WHERE customer_id = 2;

-- Then delete the customer
DELETE FROM public.customer
WHERE id = 2;
