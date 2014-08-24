setPath <- function(){
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  
  # Works, path is missing
  shell(paste0("C:/Windows/System32/setx.exe PATH '", installPath, "'"), intern=TRUE)
  
  if(sysName == "Windows"){
    pathName <- "Path="
    envVar <- shell('set Path', intern = T)
    envVar <- envVar[grep(pathName, envVar)]
    envVar <- unlist(strsplit(envVar, ";"))
    envVar <- gsub(pattern=pathName, replacement="", x=envVar)
    envVar <- gsub(pattern="[\\]", replacement="/", x=envVar)
  }  
}

installUtilities <- function(installIE=TRUE, installChrome=TRUE){
  
  # System information
  sysName <- Sys.info()["sysname"][[1]]
  usrName <- Sys.info()["user"][[1]]
  bitFormat <- Sys.info()["machine"][[1]]
  utilPath <- file.path(find.package("RSeleniumUtilities"))
  
  if(sysName == "Windows"){
    installPath <- paste0("C:/Users/", usrName, "/AppData/Local/Selenium/")
    chromePath <- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver.exe")
    iePath <- paste0(utilPath, "/bin/", bitFormat, "InternetExplorer", sysName, "/IEDriverServer.exe")
  }
    
  if(sysName == "Linux") {
    installPath <- paste0("/home/", usrName, "/.selenium")
    chromePath <- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver")
  }
  
  seleniumPath <- paste0(utilPath, "/seleniumJar/selenium-server-standalone.jar")
  
  # Remove and create hidden selenium directory
  unlink(file.path(installPath), recursive=TRUE, force=TRUE)
  dir.create(installPath)
  
  # Copy files
  file.copy(from=chromePath, to=installPath)
  file.copy(from=iePath, to=installPath)
  file.copy(from=seleniumPath, to=installPath)
}
installUtilities()
