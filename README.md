# campaign manager

a dnd campaign manager matching dungeon masters with players.

## setup

```bash
cp .env.example .env
docker compose up -d
bundle install
rails db:migrate
```

## run

```bash
rails server
```

## login

enter your email. click the button. a new tab opens with your login link.

links expire in 15 minutes.

## docs

see [prd.md](docs/prd.md) for full product spec.
