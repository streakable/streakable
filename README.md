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

[asdf]:    https://github.com/asdf-vm/asdf
