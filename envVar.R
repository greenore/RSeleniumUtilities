# System information
sysName <- Sys.info()["sysname"][[1]]
usrName <- Sys.info()["user"][[1]]

if(sysName == "Windows"){
  pathName <- "Path="
  envVar <- shell('set Path', intern = T)
  envVar <- envVar[grep(pathName, envVar)]
  envVar <- unlist(strsplit(envVar, ";"))
  envVar <- gsub(pattern=pathName, replacement="", x=envVar)
  envVar <- gsub(pattern="[\\]", replacement="/", x=envVar)
}
dataDir
?unlink
dataDir
file.remove())
?do.call


envVar

dir.create(file.path(mainDir, subDir))
setwd(file.path(mainDir, subDir))

installUtilities <- function(installIE=TRUE, installChrome=TRUE){
  
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  bitFormat <- Sys.info()["machine"][[1]]
  utilPath <- file.path(find.package("RSeleniumUtilities"))

  if(sysName == "Windows") {
    installPath <- paste0("C:/Users/", usrName, "/AppData/Local/Selenium/")
    chromePath <- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver.exe")
    iePath <- paste0(utilPath, "/bin/", bitFormat, "InternetExplorer", sysName, "/IEDriverServer.exe")
  }
  
  C:\Users\b029580\NoBackupData\Software\R\R-3.1.1\library\RSeleniumUtilities\bin\x86ChromeWindows\
  
  
  if(sysName == "Linux") {
    installPath <- paste0("/home/", usrName, "/.selenium")
    chromePath <- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName)
  }

  seleniumPath <- paste0(utilPath, "/seleniumJar/selenium-server-standalone.jar")

  # Remove old directory
  unlink(file.path(installPath), recursive=TRUE, force=TRUE)
  dir.create(installPath)

  # Copy files
  file.copy(from=chromePath, to=installPath)
  
  
# Create a hidden Selenium directory if it doesn't exist yet
  if(file.exists(file.path(dataDir))==FALSE){
  }
  
  list.files(dataDir)
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
}

