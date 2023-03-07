# PIP-II Parameter Page Web Application

This is the PIP-II Parameter Page web application. 

## Development Environment

TODO

## Running

`flutter run`

## Executing Integration tests (UI Tests)

Get chromedriver from: https://chromedriver.chromium.org/downloads

Start chromedriver on port 4444

Run tests:

* In browser: `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d chrome`

* Or headless: `flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d web-server`
