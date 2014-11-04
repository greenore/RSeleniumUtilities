RSeleniumUtilities
==================

Binaries, webdrivers and a couple of helper functions for the [RSelenium][] package. 

## Introduction

[Selenium][] is a open source tool that automates web browsers. The [RSelenium][] package is intended to provide access to Selenium and use it for web navigation and to ease the path for web scraping and/or web side testing in R. __RSeleniumUtilities__ is a companion package that contains the Selenium Server file as well as various driver files and helper functions.

### Available Webbrowsers
- Firefox (Windows & Linux)
- Google Chrome (Windows & Linux)
- Internet Explorer (Windows)

### Versions numbers
- Selenium Server (2.44.0)
- Internet Explorer Binding (2.44.0)
- Google Chrome Binding (2.12)

### Tutorial
The [RSelenium][] Github page has a couple of nice tutorials available. Furthermore, there is the [RSelenium Webinar][].

## Reason for the RSeleniumUtilities package

The [CRAN Repository Policy][] propose, as a general rule, that neither data nor documentation should exceed 5MB. Where a large amount of "data" (read here jar files and webdriver) is required, consideration should be given to a separate data-only package which can be updated only rarely (since older versions of packages are archived in perpetuity).

As a result of that, the __RSeleniumUtilities__ is a binary and jar files-only package. It exist another package, [RSelenium][], which is intended to provide access to Selenium.

## Installation
The __RSeleniumUtilities__ is not available on CRAN, but you can install it from Github with:

```
library(devtools)
install_github(repo="greenore/RSeleniumUtilities")
```

[Selenium]: http://docs.seleniumhq.org/
[RSelenium]: https://github.com/ropensci/RSelenium
[RSelenium Webinar]: https://www.youtube.com/watch?v=ic65SWRWrKA
[CRAN Repository Policy]: http://cran.r-project.org/web/packages/policies.html
