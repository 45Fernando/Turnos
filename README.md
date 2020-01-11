# Turnos

## Instalando Elixir Version: 1.9.4
En Ubuntu 14.04/16.04/17.04/18.04/19.04:

En la terminal.

- Primero añadir el repo de Erlang:<br/>
`wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb`

- Segundo:<br/>
`sudo apt-get update`<br/>

- Tercero, instalar la plataforma de Erlang/OTP:<br/>
`sudo apt-get install esl-erlang`<br/>

- Cuarto, instalar Elixir:<br/>
`sudo apt-get install elixir`<br/>

- Quinto, añadirla ruta de Elixir a la ruta de variables de ambiente:<br/>
En el archivo .profile, que esta en la carpeta personal, pegar al ultimo del archivo lo siguiente:<br/>
`export PATH="$PATH:/usr/lib/elixir/bin"`<br/>

- Sexto:<br/>
Se puede chequear la version de Elixir, escribiendo en la terminal:
`elixir --version`<br/>

### Documentacion:<br/>
- https://elixir-lang.org/learning.html<br/>
- https://hexdocs.pm/elixir/Kernel.html#content

## Instalando Phoenix Version: 1.4.11<br/>

En la terminal.<br/>

- Primero, instalar o actualizar Hex:<br/>
`mix local.hex`<br/>

- Segundo, instalar Phoenix:<br/>
`mix archive.install hex phx_new 1.4.11`<br/>

- Tercero, instalar NodeJS Version: 12.13.1:<br/>
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt install nodejs
```
- Cuarto, instalar PostGreSQL Version: 12.1:<br/>
```
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install postgresql postgresql-contrib
```

- Quinto, para el hot reload, instalar inotify-tools:<br/>
`apt-get install inotify-tools`

### Documentacion:<br/>
- https://hexdocs.pm/phoenix/installation.html

## Hola

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
