flysafe
=======

Flysafe is a web app based on sinatra for corp management in eve and other tools

Requires:

redis

Getting started:

```bash
redis-server > /dev/null & # or however you want to start redis-server
git clone https://github.com/mattbailey/flysafe
cd flysafe
cp config/redis.yml.dist config/redis.yml
$EDITOR config/redis.yml
bundle install
rake configure
rake cache:itemid # This takes a few mintes, caches all itemID => itemName
thin start
```


This is cool.
=============

Donate some ISK to 'ribo' in game, or make some pull requests!
