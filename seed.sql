CREATE TABLE posts (
  id INT AUTO_INCREMENT,
  created_at TIMESTAMP,
  title VARCHAR(255),
  author_email VARCHAR(255),
  content TEXT,
  PRIMARY KEY(id)
);

CREATE TABLE authors (
  id INT AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE,
  name VARCHAR(255),
  PRIMARY KEY(id)
);

for i in `seq 1 40000`; do
  mysql -u root db -e 'INSERT INTO authors (name, email) VALUES (SUBSTRING(MD5(RAND()) FROM 1 FOR 10), CONCAT(SUBSTRING(MD5(RAND()) FROM 1 FOR 10), "@example.com");'
done

for i in `seq 1 10000`; do
  mysql -u root db -e 'INSERT INTO posts (title, created_at, content, author_id) VALUES (SUBSTRING(MD5(RAND()) FROM 1 FOR 10), NOW(), MD5(RAND()), FLOOR((RAND() * 10000) + 1));'
done
