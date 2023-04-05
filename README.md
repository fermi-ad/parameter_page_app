# PIP-II Parameter Page Web Application

![Parameter Page in Chrome](screenshots/main-screenshot.png "Parameter Page in Chrome")

This is the PIP-II Parameter Page web application. 

## Development Environment

TODO

## Running

To run the application in Chrome:

```
flutter run -d chrome
```

## Unit tests

Lowest-level tests organized around classes or modules.

To run:

```
flutter test test/unit_tests
```

## Widget tests

Tests at the Widget level without needing a heavy environment.

To run:

```
flutter test test/widget_tests
```

## Integration tests (UI Tests)

High-level tests that execute through the user inteface.  Requires chromedriver to run.  Tests are organized into a group for each user story.

Get chromedriver from: https://chromedriver.chromium.org/downloads

Start chromedriver on port 4444 (on my Windows machine I have chromedriver installed to C:\chromedriver_win32):

```
C:\chromedriver_win32\chromedriver.exe --port=4444
```

Run tests:

Note: each test file needs to be invoked manually.  Replace display_parameter_page_test.dart with the test group you want to run.

* In browser: `flutter drive --driver=test_driver/integration_test.dart --target=test/integration_tests/display_parameter_page_test.dart -d chrome`

* Or headless: `flutter drive --driver=test_driver/integration_test.dart --target=test/integration_tests/display_parameter_page_test -d web-server`
