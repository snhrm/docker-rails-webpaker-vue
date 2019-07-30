# 環境構築

## アプリケーション作成
[dockerでrails環境構築](https://github.com/snhrm/docker-create-rails-app)
```
docker-compose run --rm rails rails new . --force --database=mysql --webpack=vue --skip-coffee

docker-compose run --rm rails rake webpacker:install
docker-compose run --rm rails rake webpacker:install:vue
```
## 初期セットアップ
`database.yml`の設定
```
$ vim config/database.yml
```
```ruby
default: &default
  adapter: mysql2
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch('DATABASE_USER') { 'root' } %>
  password: <%= ENV.fetch('DATABASE_PASSWORD') { 'password' } %>
  host: <%= ENV.fetch('DATABASE_HOST') { 'localhost' } %>
  port: <%= ENV.fetch('DATABASE_PORT') { 3306 } %>
```

`webpaker`の設定
```
$ vim config/initializers/content_security_policy.rb
```
```ruby
Rails.application.config.content_security_policy do |policy|
  policy.connect_src :self, :https, "http://localhost:3035", "ws://localhost:3035" if Rails.env.development?
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  else
    policy.script_src :self, :https
  end
end
```
[https://github.com/rails/webpacker](https://github.com/rails/webpacker)

## webpackerを自動で起動できるように設定
```
vim docker-compose.yml
```
```yml
  rails: &app_base
    build:
      context: .
    command:  /bin/sh -c "rm -f /app/tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    # 省略
  webpacker:
    <<: *app_base
    command: "bin/webpack-dev-server"
    ports:
      - "3035:3035"
    depends_on:
      - rails
    tty: false
    stdin_open: false
```

`DB`作成
```
docker-compose up -d db

docker-compose run --rm rails rake bin/setup
```

## 起動
```
docker-compose up
```