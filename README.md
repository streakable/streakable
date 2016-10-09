# streakable

## What's is this?

Streakable is the web service that helps you to keep tryin' like github streak.
You can record your contributions for your target,
and streakable visualizes your contributions.


## Development

1. Install [asdf][] and run `asdf install`
2. Install posgresql and create postgres(pass: postgres) user
3. Run below:

    ```shell
    npm install
    mix deps.get
    mix ecto.create
    mix ecto.migrate
    mix phoenix.server
    ```

## Deploy on heroku

```shell
heroku apps:create streakable
heroku config:set SECRET_KEY_BASE=$(mix phoenix.gen.secret)
heroku buildpacks:set https://github.com/gjaldon/phoenix-static-buildpack
heroku buildpacks:add --index 1 https://github.com/HashNuke/heroku-buildpack-elixir
heroku addons:create heroku-postgresql:hobby-dev
heroku config:set POOL_SIZE=18
heroku config:set SECRET_KEY_BASE="`mix phoenix.gen.secret`"
git push heroku master
heroku run mix ecto.migrate
```

[asdf]:    https://github.com/asdf-vm/asdf


[heroku]: http://www.phoenixframework.org/docs/heroku
