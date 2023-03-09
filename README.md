# PIP-II Parameter Page Web Application

This is the PIP-II Parameter Page web application. 

## Development Environment

TODO

## Running

`flutter run`

## Unit tests

Lowest-level tests organized around classes or modules.

To run:

`flutter test`

## Widget tests

Tests at the Widget level without needing a heavy environment.

## Integration tests (UI Tests)

High-level tests that execute through the user inteface.  Requires chromedriver to run.

Get chromedriver from: https://chromedriver.chromium.org/downloads

Start chromedriver on port 4444

Run tests:

* In browser: `flutter drive --driver=test_driver/integration_test.dart --target=test/integration_tests/app_test.dart -d chrome`

* Or headless: `flutter drive --driver=test_driver/integration_test.dart --target=test/integration_tests/app_test.dart -d web-server`
