# streakable [![Build Status](https://travis-ci.org/streakable/streakable.svg?branch=master)](https://travis-ci.org/streakable/streakable)

## What's this?

Streakable is the web service that helps you to keep tryin' like github streak.
You can record your contributions for your target,
and streakable visualizes your contributions.


## Development

1. Install [asdf][] and run `asdf install`
2. npm install --global yarn
3. Install posgresql
4. Create "postgres" role (password: "postgres"):
   ```shell
   createuser -d -U your_name -P postgres`
   ```
5. Install dependencies
   ```shell
   mix deps.get
   yarn install
   ```
6. Start postgres if it doesn't run
   ```shell
   pg_ctl start
   ```
7. Setup database
   ```shell
   mix ecto.create
   mix ecto.migrate
   ```
8. Run below:
    ```shell
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
