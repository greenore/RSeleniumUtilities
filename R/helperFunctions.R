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
firefoxDriver <- function(useProfile=FALSE, profileName="default", profileDir="default", baseEncrypton=TRUE){
    startServer(); Sys.sleep(2)
  
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  
  if(useProfile & profileDir == "default"){
    if(sysName == "Windows") {
      profileDir <- paste0("C:/Users/", usrName, "/AppData/Roaming/Mozilla/Firefox/Profiles")
    }
    
    if(sysName == "Linux") {
      profileDir <- paste0("/home/", usrName, "/.mozilla/firefox")
    }
    
    profFiles <- list.files(profileDir)
    expr <- paste0("[[:alnum:]]{1, }", ".", profileName)
    profFile <- regmatches(profFiles, regexpr(expr, profFiles))
    profDir <- paste0(profileDir, "/", profFile)
    fprof <- getFirefoxProfile(profDir, useBase=baseEncrypton)
    remDr <- remoteDriver(browserName='firefox', extraCapabilities=fprof)
    
    if(length(profFile) == 0){
      warning(paste0('NO PROFILE FOLDER UNDER THE NAME: "', profileName, '" ...'))
    } else {
      remDr$open(); remDr$maxWindowSize()
      remDr
    }
    
  } else {
    remDr <- remoteDriver(browserName='firefox')
    remDr$open(); remDr$maxWindowSize()
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
chromeDriver <- function(useProfile=FALSE, profileName="Default", profileDir="Default", internalTesting=FALSE){
  startServer(); Sys.sleep(2)

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
  remDr$open()
  remDr$maxWindowSize()
  remDr
}
