#' Use Firefox Profiles
#' 
#' \code{firefoxDriver}
#' A utility function for easy and automated access to the firefox driver. 
#' @param useProfile 
#' @param profileDir Specifies the user data directory, which is where the browser will look for all of its state.
#' @param profileName Selects directory of profile to associate with the first browser launched.
#' @param baseEncrypton
#' @export
#' @section Detail:
#' The profile directory is contained in the user directory and by default is named "Default" 
firefoxDriver <- function(useProfile=FALSE, profileName="default", profileDir="default",
                          baseEncrypton=TRUE){
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  
  if(useProfile & profileDir == "default"){
    if(sysName == "Windows") {
      dataDir <- paste0("C:/Users/", usrName, "/AppData/Roaming/Mozilla/Firefox/Profiles")
    }
    
    if(sysName == "Linux") {
      profileDir <- paste0("/home/", usrName, "/.mozilla/firefox")
    }
    
    profFiles <- list.files(dataDir)
    expr <- paste0("[[:alnum:]]{1, }", ".", profileName)
    profFile <- regmatches(profFiles, regexpr(expr, profFiles))
    profDir <- paste0(dataDir, "/", profFile)
    fprof <- getFirefoxProfile(profDir, useBase=baseEncrypton)
    remDr <- remoteDriver(browserName='firefox', extraCapabilities=fprof)
    
    if(length(profFile) == 0){
      warning(paste0('NO PROFILE FOLDER UNDER THE NAME: "', profileName, '" ...'))
    } else {
      remDr
    }
    
  } else {
    remDr <- remoteDriver(browserName='firefox')
    remDr
  }
}

#' Use Chrome Profiles
#' 
#' \code{chromeDriver}
#' A utility function for easy and automated access to the Chrome driver. 
#' @param useProfile 
#' @param profileDir Specifies the user data directory, which is where the browser will look for all of its state.
#' @param profileName Selects directory of profile to associate with the first browser launched.
#' @param internalTesting 
#' @export
#' @section Detail:
#' The profile directory is contained in the user directory and by default is named "Default" 
chromeDriver <- function(useProfile=FALSE, profileName="Default", profileDir="Default",
                         internalTesting=FALSE){
  
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  
  # Find profile path according to OS
  if(useProfile & profileDir == "Default"){
    if(sysName == "Windows") {
      profileDir <- paste0("C:/Users/", usrName, "/AppData/Local/Google/Chrome/User Data")
    }
    
    if(sysName == "Linux") {
      profileDir <- paste0("/home/", usrName, "/.config/google-chrome")
    }
  }
  
  # Set chrome options (extraCapabilities)
  args <- NULL
  if(useProfile){
    args <- append(args, list(paste0('--user-data-dir=', profileDir), paste0('--profile-directory=', profileName)))
  }
  
  if(internalTesting){
    args <- append(args, list('--test-type'))
  }
  
  if(is.null(args)){
    cOptions <- list(NULL)
  } else {
    cOptions <- list(chromeOptions = list(args = args))    
  }
  
  # Set remote drive according to chrome settings
  remDr <- remoteDriver(browserName='chrome', extraCapabilities=cOptions)    
  remDr
}

#' Check for Server binary (baloise version)
#' 
#' \code{checkSeleniumServer}
#' A utility function to check if the Selenium Server stanalone binary is present.
#' @param selName The name of the Selenium Server File.
#' @param update A boolean indicating whether to update the binary if it is present.
#' @param proxyUrl
#' @param selName
#' @export
#' @section Detail: The downloads for the Selenium project can be found at http://selenium-release.storage.googleapis.com/index.html. This convience function downloads the standalone server and places it in the RSelenium package directory bin folder by default.
#' @examples
#' \dontrun{
#' checkSeleniumServer(update=F)
#' }

checkSeleniumServer <- function(dir = NULL, update = FALSE, proxyUrl="webproxy.balgroupit.com",
                                selName="selenium-server-standalone.jar"){
  
  # Setup
  selDIR <- ifelse(is.null(dir), file.path(find.package("RSelenium"), 
                                           "bin"), dir)
  selFILE <- file.path(selDIR, selName)
  selURL <- "http://selenium-release.storage.googleapis.com"
  
  # Function to ping a server (i.e., does the server exist)
  pingServer <- function(url, stderr=F, stdout=F, ...){
    vec <- suppressWarnings(system2("ping", url, stderr=stderr, stdout=stdout, ...))
    if (vec == 0){TRUE} else {FALSE}
  }
  
  if(pingServer(proxyUrl) && !file.exists(selFILE)){
    warning(paste0("\n\nThe Selenium server file can't be downloaded directly through the Baloise Proxy...\n",
                   "Go to: 'www.seleniumhq.org/download'...\n\n",
                   "Download the newest Selenium Server (formerly Selenium RC Server) file...\n",
                   "Rename it to: '", selName,"' ...\n\n",
                   "Move it to:\n",
                   selDIR))
  }
  
  if(!pingServer(proxyUrl)){
    if (update || !file.exists(selFILE)) {
      selXML <- xmlParse(paste0(selURL), "/?delimiter=")
      selJAR <- xpathSApply(selXML, "//s:Key[contains(text(),'selenium-server-standalone')]", namespaces = c(s = "http://doc.s3.amazonaws.com/2006-03-01"), xmlValue)
      # get the most up-to-date jar
      selJAR <- selJAR[order(as.numeric(gsub("(.*)/.*", "\\1",selJAR)), decreasing = TRUE)][1]
      
      dir.create(selDIR, showWarnings=FALSE)
      print("DOWNLOADING STANDALONE SELENIUM SERVER. THIS MAY TAKE SEVERAL MINUTES")
      download.file(paste0( selURL, "/", selJAR), selFILE, mode = "wb")
    }
  }
}
