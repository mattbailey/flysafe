flysafe
=======

Flysafe is a web app based on sinatra for corp management in eve and other tools

Requires:

redis

Getting started:

```
git clone https://github.com/mattbailey/flysafe
cd flysafe
cp config/redis.yml.dist config/redis.yml
$EDITOR config/redis.yml
bundle install
rake configure
thin
```
