-- V3: Create the hierarchical categories table

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name TEXT,
    parent_id INT REFERENCES categories(id)
);
