RSeleniumUtils
==============

Binaries, webdrivers and different utilty functions for the RSelenium package (e.g., selenium-server-standalone.jar)

## Introduction

[Selenium][] is a suite of tools in order to automate web browsers. The [RSelenium][] package is intended to provide access to Selenium and use it for web navigation and to ease the path for web scraping and/or web side testing in R. The __RSeleniumBinaries__ package contains the Selenium Server file as well as various driver files.

### Available Webbrowsers
- Firefox
- Google Chrome
- Internet Explorer

### Tutorial
The [RSelenium][] Github page has a couple of nice tutorials available. Furthemore, there is a nice [RSelenium Webinar][] available.


## Reason for the RSeleniumBinaries

The [CRAN Repository Policy][] propose, as a general rule, that neither data nor documentation should exceed 5MB. Where a large amount of "data" (read here jar files) is required, consideration should be given to a separate data-only package which can be updated only rarely (since older versions of packages are archived in perpetuity).

As a result of that, the __RSeleniumBinaries__ is a binary and jar files-only package. It exist another package, [RSelenium][], which is intended to provide access to Selenium. 

## Installation
For the above reason the __RSeleniumBinaries__ is not available on CRAN, but you can install it from github with:

```
library(devtools)
install_github(repo="greenore/RSeleniumBinaries")
```

[Selenium]: http://docs.seleniumhq.org/
[RSelenium]: https://github.com/ropensci/RSelenium
[RSelenium Webinar]: https://www.youtube.com/watch?v=ic65SWRWrKA
[CRAN Repository Policy]: http://cran.r-project.org/web/packages/policies.html