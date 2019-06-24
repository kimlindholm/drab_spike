# Drab Spike

[![CircleCI](https://circleci.com/gh/kimlindholm/drab_spike/tree/master.svg?style=shield)](https://circleci.com/gh/kimlindholm/drab_spike/tree/master)
[![SourceLevel](https://app.sourcelevel.io/github/kimlindholm/drab_spike.svg)](https://app.sourcelevel.io/github/kimlindholm/drab_spike)
[![codebeat badge](https://codebeat.co/badges/07ad392f-cf71-4b5a-a933-903a952588a7)](https://codebeat.co/projects/github-com-kimlindholm-drab_spike-master)

Proof-of-concept app using Drab

## Description

[Drab](https://github.com/grych/drab) is an interesting Phoenix library that allows you to move front-end logic to the server side. In this spike app, I used Drab to trigger animations from the backend and experimented with how network latency affects the user experience. All the UI updates you see here come from [`page_commander.ex`](https://github.com/kimlindholm/drab_spike/blob/master/lib/drab_spike_web/commanders/page_commander.ex):

![Drab iPhone X Simulator](https://user-images.githubusercontent.com/1413569/32144199-bb62ed8e-bce7-11e7-96fe-56ef343be20e.gif)

## What I Learned

Deploying the app to a distant server did degrade the UX as animations that are supposed to fire simultaneously now get out of sync etc.  Clearly, server-triggered UI events shouldn't be used when timing is critical as the more latency there is, the more sluggish your app feels. So yes, we're still stuck with front-end tools where that instantaneous feel is required. But there's plenty of other use cases where Drab seems to shine and I'd definitely prefer Drab to the more traditional ajax calls or polling the backend for changes with long-running processes.

To see the spike app in action, you can deploy it to Heroku by clicking the button below.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/kimlindholm/drab_spike)

For some inspiration on how you could benefit from Drab in your next project, check out the [official demo page](https://tg.pl/drab).

## Requirements

* Phoenix 1.3.0 or later
* Elixir 1.5 or later
* Erlang 20 or later

## Installation

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix s`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## License

See [LICENSE](LICENSE).
