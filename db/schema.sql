DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS listings;
DROP TABLE IF EXISTS message_templates;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS crawlers;

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR NOT NULL,
    password VARCHAR NOT NULL
);

CREATE TABLE listings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR NOT NULL,
    craigslist_id INTEGER NOT NULL,
    email VARCHAR NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE message_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    text TEXT NOT NULL
);

CREATE TABLE messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sent_at DATETIME NULL,
    user_id INTEGER NOT NULL,
    message_template_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(message_template_id) REFERENCES message_templates(id)
);

CREATE TABLE crawlers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    location VARCHAR NOT NULL,
    section VARCHAR NOT NULL,
    cat BOOLEAN NULL,
    dog BOOLEAN NULL,
    max_price INTEGER NULL,
    min_price INTEGER NULL,
    query VARCHAR NULL,
    bedrooms INTEGER NULL,
    sub_region VARCHAR NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY(user_id) REFERENCES users(id)
);