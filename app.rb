require 'sinatra'
require 'mysql2'

get '/' do
  client = Mysql2::Client.new(
    host: ENV['MYSQL_HOST'],
    port: ENV['MYSQL_PORT'],
    username: ENV['MYSQL_USER'],
    password: ENV['MYSQL_PASSWORD'],
    database: ENV['MYSQL_DBNAME']
  )
  posts = client.query("SELECT * FROM posts INNER JOIN authors ON posts.author_email = authors.email ORDER BY created_at DESC")
  @top_5_posts = posts.to_a[0..4]
  erb :index
end
