# campaign manager

a dnd campaign manager with magic link login.

## setup

copy env vars:
```bash
cp .env.example .env
```

start postgres:
```bash
docker compose up -d
```

install gems:
```bash
bundle install
```

setup db:
```bash
rails db:migrate
```

## run

```bash
rails server
```

go to localhost:3000

## login

enter your email, click the button. a new tab opens with your login link. click it and you're in.

links expire in 15 minutes.

## export db to csv

```bash
cd python_scripts
pip install -r requirements.txt
python export_to_csv.py
```

this exports all tables to csv files in the current directory.
