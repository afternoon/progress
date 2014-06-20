Progress
========

Show progress reports for Jira versions.

Build
-----

    $ npm install
    $ make

Run
---

Create a config file:

    module.exports =
      port: 3000
      jira:
        url: 'https://jira.example.com'

Run `app/bin/progress` to start the app:

    $ ./app/bin/progress

Browse to `http://localhost:3000` (replace port number as appropriate).
