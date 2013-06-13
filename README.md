## Pair Program With Me - Matcher

A sinatra app with github auth for Avdi

* see [ppwm](https://github.com/avdi/ppwm), [a ppwm scraper](https://github.com/martyhines/pair_with_me), and [rubypair](https://github.com/rubypair/rubypair)

## In a nutshell

As an Avdi<br/>
I want to promote pair programming<br/>
So that hackers will be happier<br/>

*When* I distribute cards at a conference which say:

    Find your pair!
    Go to: pairprogramwith.me/match
    Enter: ABC123

*And* every card has one identical twin<br/>
*When* Jane, the first recipient, follows the directions on her card<br/>
*And* she logs in with Github<br/>
*And* she enters her email address<br/>
*Then* she is told:

    Your pair hasn't signed in yet. Keep your fingers crossed!"

*When* the second recipient, Bob, follows the directions on his card<br/>
*Then* he is told:

    You've been matched with Jane! Click here to email her!

## FAQ

*Why match based on fixed codes? Why not just randomly match people as they arrive?*

Because:

1. It's a fun twist; and
2. It means if you *don't* sign in, someone out there doesn't have a pair. And who wants to leave their pair in the lurch?! Guilt FTW!

## TODO

**Check the [issues](https://github.com/rubyrogues/ppwm-matcher/issues) first!**

* a way to view created codes
* fix deprecation warnings from github auth
* don't let codes be re-used by other users
* anything else you can think of:
  * security
  * design
  * letting you know when your 'pair' signed in
  * letting an admin view a list of paired users and codes
  * maybe leave messages for avdi in some queue...
  * add admin links (need to create an admin user, user roles) e.g. to create codes etc
  * UX
  * analytics?

## Setup

You'll want to have two [github applications](https://github.com/settings/applications/new), one for development, and one for production.

For each app, Make a note of the client ID and secret.

For production, enter your application URL `http://<domain>/` and
set the callback URL should be `http://<domain>/auth/github/callback`.

For development, set your application URL to `http://localhost/` and set your
callback URL to `http://localhost:9393/auth/github/callback`

### For development

Install the gems:

```bash
bundle
```

Then set up your the application config and database settings

```bash
./serve.sh setup
```

Update the GITHUB keys in your `config/application.yml`


Finally start the web server using thin:

```bash
./serve.sh start
```

If you want to daemonize your dev server

```bash
./serve.sh start -d
./serve.sh stop
```

#### Testing

Migrate your test database

```bash
RACK_ENV=test rake db:migrate
```

Run rspec

```bash
rspec
```

### Deploying to heroku (production)

  ```bash
  heroku addons:add heroku-postgresql:dev
  heroku config:set GITHUB_CLIENT_ID="<from GH>" GITHUB_CLIENT_SECRET="<from GH>"
  git push heroku master
  heroku run rake db:migrate
  ```

## License

Ask Avdi
