# Changelog

All notable changes to `hermod` will be documented in this file

## [2.0.0] - 2019-04-24
### Changed
- Changed the log file names that are checked, as core 2.3 introduced new log filenames and structure. This is a breaking change as `hermod` will no longer work with versions that use the previous filenames.

## [1.2.0] - 2019-03-26
### Added
- Introduced `hermod share` to facilitate sharing snapshots with others

## [1.1.0] - 2019-03-11
### Fixed
- Make snapshot module work with new core 2.2 CLI

## [1.0.1] - 2019-02-16
### Fixed
- Snapshot module will remove broken snapshots before proceeding

## [1.0.0] - 2019-02-15
### Added
- Initial version release of `hermod`
- Monitoring capabilities based on log messages
- Function log() now adds timestamp to lines
- Removed variables.sh in favor of .hermod config file
- Introduced the snapshot module
