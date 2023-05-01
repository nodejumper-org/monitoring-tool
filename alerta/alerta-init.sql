CREATE TABLE IF NOT EXISTS api_keys (
    id SERIAL PRIMARY KEY,
    "user" VARCHAR(50),
    scopes VARCHAR(255),
    text VARCHAR(255),
    expire_time TIMESTAMPTZ,
    count INTEGER,
    last_used_time TIMESTAMPTZ,
    customer VARCHAR(255),
    api_key VARCHAR(255) UNIQUE
);

INSERT INTO api_keys ("user", scopes, text, expire_time, count, last_used_time, customer, api_key)
VALUES ('admin', 'admin,read,write', 'Alertmanager', '2099-12-31 23:59:59', 0, NOW(), '', 'c07ba4b7-7b4e-4f6d-9739-794cbae1ca00');
