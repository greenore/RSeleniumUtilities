#' Use Firefox Profiles
#' 
#' \code{firefoxDriver}
#' A utility function for easy and automated access to the firefox driver. 
#' @param use_profile 
#' @param profile_dir Specifies the user data directory, which is where the browser will look for all of its state.
#' @param profile_name Selects directory of profile to associate with the first browser launched.
#' @param base_encrypton
#' @export
#' @section Detail:
#' The profile directory is contained in the user directory and by default is named "Default" 
firefoxDriver <- function(use_profile=FALSE, profile_name="default", profile_dir="default", base_encrypton=TRUE){
    startServer(); Sys.sleep(2)
  
  # System information
  sys.info <- sysInfo()
  
  if(use_profile & profile_dir == "default"){
    if(sys.info$sys_name == "Windows") {
      profile_dir <- paste0("C:/Users/", sys.info$usr_name, "/AppData/Roaming/Mozilla/Firefox/Profiles")
    }
    
    if(sys.info$sys_name == "Linux") {
      profile_dir <- paste0("/home/", sys.info$usr_name, "/.mozilla/firefox")
    }
    
    prof_files <- list.files(profile_dir)
    expr <- paste0("[[:alnum:]]{1, }", ".", profile_name)
    prof_file <- regmatches(prof_files, regexpr(expr, prof_files))
    profDir <- paste0(profile_dir, "/", prof_file)
    fprof <- getFirefoxProfile(profDir, useBase=base_encrypton)
    remDr <- remoteDriver(browserName='firefox', extraCapabilities=fprof)
    
    if(length(prof_file) == 0){
      warning(paste0('NO PROFILE FOLDER UNDER THE NAME: "', profile_name, '" ...'))
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
#' @param use_profile 
#' @param profile_dir Specifies the user data directory, which is where the browser will look for all of its state.
#' @param profile_name Selects directory of profile to associate with the first browser launched.
#' @param internal_testing 
#' @export
#' @section Detail:
#' The profile directory is contained in the user directory and by default is named "Default" 
chromeDriver <- function(use_profile=FALSE, profile_name="Default",
                         profile_dir="Default", internal_testing=FALSE){
  startServer(); Sys.sleep(2)

  # System information
  sys.info <- sysInfo()
  
  # Find profile path according to OS
  if(use_profile & profile_dir == "Default"){
    if(sys.info$sys_name == "Windows") {
      profile_dir <- paste0("C:/Users/", sys.info$usr_name, "/AppData/Local/Google/Chrome/User Data")
    }
    
    if(sys.info$sys_name == "Linux") {
      profile_dir <- paste0("/home/", sys.info$usr_name, "/.config/google-chrome")
    }
  }
  
  # Set chrome options (extraCapabilities)
  args <- NULL
  if(use_profile){
    args <- append(args, list(paste0('--user-data-dir=', profile_dir), paste0('--profile-directory=', profile_name)))
  }
  
  if(internal_testing){
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

#' Use Internet Explorer
#' 
#' \code{ieDriver}
#' A utility function for easy and automated access to the Chrome driver. 
#' @export
#' @section Detail:
ieDriver <- function(){
  startServer(); Sys.sleep(2)
  
  # System information
  sys.info <- sysInfo()
  
  # Find profile path according to OS
  if(sys.info$sys_name == "Windows") {
      profile_dir <- paste0("C:/Users/", sys.info$usr_name, "/AppData/Local/Google/Chrome/User Data")
  }
    
  if(sys.info$sys_name == "Linux") {
    profile_dir <- paste0("/home/", sys.info$usr_name, "/.config/google-chrome")
  }
  
  remDr <- remoteDriver(browserName='internet explorer')    
  remDr$open()
  remDr$maxWindowSize()
  remDr
}
