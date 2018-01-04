# Changelog

All notable changes to `noah` will be documented in this file

## 1.3.2 - 2018-01-04

- Add discord notifications

## 1.3.1 - 2017-12-14

- Disable Connections before dropping the database
- Enable Connections before restoring the database

## 1.3.0 - 2017-12-11

- Remove `thefoundry` snapshot
- Remove auto-update checks
- Remove check if `ark-node` is running
- Restart `noah` during the update process
- Close PostgreSQL connections before rebuilding
- Start another rebuild if `pg_restore` fails
- Minor Bugfixes

## 1.1.9 - 2017-12-09

- Move snapshot lists to the configuration file

## 1.1.8 - 2017-12-06

- Choose a new snapshot until it exceeds 0MB

## 1.1.7 - 2017-12-06

- Add thefoundry snapshot

## 1.1.6 - 2017-12-06

- Choose a new snapshot until it returns status 200

## 1.1.5 - 2017-12-06

- Add a `.foreverignore` for logs

## 1.1.4 - 2017-12-04

- Fix hashbang issue loop rebuild
- Minor Bugfixes

## 1.1.3 - 2017-12-04

- Restart PostgreSQL after rebuilding
- Limit pg_restore to the public schema
- Monitor the hashbang issue that happens randomly every few weeks
- Minor Bugfixes

## 1.1.0 - 2017-12-01

- Implement random snapshot rebuilds
- Implement new update process
- Minor Bugfixes

## 1.0.3 - 2017-11-23

- Improve ark-node allocation
- Minor Bugfixes

## 1.0.2 - 2017-11-23

- Add index after rebuilding
- Auto-Discover what network to use
- Minor Bugfixes

## 1.0.0 - 2017-11-07

- initial release
