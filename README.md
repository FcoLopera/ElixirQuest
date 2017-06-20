# Elixirquest

Elixir Quest is a reproduction of Mozilla's [Browserquest](http://browserquest.mozilla.org/) using the following tools:
- The [Phaser](https://phaser.io/) framework for the client
- [Phoenixframework](http://www.phoenixframework.org/) for the server and client-server communication

We are also using the reproduction done by the project  [Phaserquest](https://github.com/Jerenaux/phaserquest) as a starting point.

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Note: You need an instance of postgres running in your localhost, or you can use
    docker instead of install postgres. You can use the following command to get a running
    instance of postgres running in your localhost using docker:
    ```sh
    sudo docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
    ```
Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
