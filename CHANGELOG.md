# Knil Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Added
- Added "Use this URL" button, below "I'm Feeling Lucky"
- Improve error message .cannotFetchFile with URL

### Changed
- Upgrade project to Swift 5

### Fixed
- Fetch from /.well-known folder first #14
- Throw .noData if appLinks, webCredentials, and activityContinuation are empty 

## [1.0.1(8)] - 2018-09-21
### Added
- Support iOS 12 and Swift 4.2 #12

### Fixed
- Universal Links plural
- Link composer use form sheet for iPad #7
- Improve error messages #5

## [1.0.0(7)] - 2018-08-06
### Fixed
- Custom link title not load in composer

## [1.0.0(6)] - 2018-08-05
### Added
- Duplicate Universal Link flow animation
- Handle sites that put AASA in /.well-known/ 

## [1.0.0(5)] - 2018-08-03
### Added
- Pasteboard detection for custom link adding
- Custom link title

### Fixed
- Custom link query escaping
- List item updating

## [1.0.0(4)] - 2018-08-01
### Added
- Settings About section
- Link composer

### Removed
- Action extension

## [0.3(3)] - 2018-07-31
### Added
- App icon
- Theme color
- Launch Storyboard
- Bezier path mask for app icons

## [0.2(2)] - 2018-07-30
### Added
- Deal with AASA redirection
- AASAURLSuggestor tests
- TabBar
- Update AASA
- AASA actions
- Simple custom links
- List empty state
- Detail empty state

## [0.1(1)] - 2018-07-17
### Added
- AASA data model and fetcher
- iTunes App data model and fetcher
- ListViewController
- DetailViewController
- AASAURLSuggestor
- UserDataStore
- LinkViewController
- Show app name and icon
- Open AASA in Apple's Search API Validation Tool or Branch.io 's AASA Validator
