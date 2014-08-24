sysInfo <- function(){
  sysName <<- Sys.info()["sysname"][[1]]
  usrName <<- Sys.info()["user"][[1]]
  bitFormat <<- Sys.info()["machine"][[1]]  
}

getPath <- function(){
  sysInfo()
  # System information
  utilPath <<- file.path(find.package("RSeleniumUtilities"))
  RSeleniumBinPath <<- paste0(file.path(find.package("RSelenium")), '/bin')
  
  if(sysName == "Windows") {
    installPath <<- paste0("C:/Users/", usrName, "/AppData/Local/Selenium/")
    chromePath <<- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver.exe")
    iePath <<- paste0(utilPath, "/bin/", bitFormat, "InternetExplorer", sysName, "/IEDriverServer.exe")
  }
  
  if(sysName == "Linux") {
    installPath <<- paste0("/home/", usrName, "/.selenium")
    chromePath <<- paste0(utilPath, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver")
  }
  
  seleniumPath <<- paste0(utilPath, "/bin/seleniumJar/selenium-server-standalone.jar")
}

installUtilities <- function(installIE=TRUE, installChrome=TRUE){
  sysInfo()
  
  # Remove and create hidden selenium directory
  unlink(file.path(installPath), recursive=TRUE, force=TRUE)
  dir.create(installPath)
  
  # Copy files
  file.copy(from=chromePath, to=installPath)
  if(sysName == "Windows") {
    file.copy(from=iePath, to=installPath)
  }
  file.copy(from=seleniumPath, to=RSeleniumBinPath)
}

appendFile <- function(inputTxt, filePath){
  # If the last line is not empty, add line
  fileContent <- readLines(filePath)
  if(fileContent[length(fileContent)] != "") {
    system(paste0("echo ''", " >> ", filePath), intern=TRUE)
  }
    
  # Add text to file 
  if(!inputTxt %in% fileContent) {
    system(paste0("echo '", inputTxt, "'", " >> ", filePath), intern=TRUE)
    cat(paste0("Succesfully added:\n", inputTxt, "\nto:\n", filePath, "\n"))  
  } else {
    warning(paste0("\n\nDid not add:\n", inputTxt, "\nto:\n", filePath, "\n\nText already exists...\n"))
  }
}

setPath <- function(){

  if(sysName == "Windows") {
    shell(paste0("C:/Windows/System32/setx.exe PATH '", installPath, "'"), intern=TRUE)
  }
  
  if(sysName == "Linux") {
    profilePath <<- paste0("/home/", usrName, "/.profile")
    appendFile('# Add Selenium to the PATH Environment', profilePath)
    appendFile(paste0("export PATH=$PATH:", installPath), profilePath)
    warning("Reboot the Computer in order for the changes to take effect!!!")
  }
}

checkPath <- function(){
  
  if(sysName == "Windows") {
    pathName <- "Path="
    envVar <- shell('set Path', intern=TRUE)
    envVar <- envVar[grep(pathName, envVar)]
    envVar <- unlist(strsplit(envVar, ";"))
    envVar <- gsub(pattern=pathName, replacement="", x=envVar)
    envVar <- gsub(pattern="[\\]", replacement="/", x=envVar)
  }

  if(sysName == "Linux") {
    envVar <- system('echo "$PATH"', intern=TRUE)
    envVar <- unlist(strsplit(envVar, ":"))
  }
  
  if(installPath %in% envVar) {
    message("The Selenium is correctly added to the system environment variables...")
    TRUE
  } else {
    warning(paste0("\n\nSelenium is not found in the path variable...\n",
                   "execute: setPath() or add the variable manually to the path...\n",
                   "NOTE: It might be that you need to restart the system for changes to take effect..."))
    FALSE
  }
}


# The Selenium Server was started with 
# -Dwebdriver.chrome.driver=c:\path\to\your\chromedriver.exe

getPath()
if(!checkPath()){
  setPath()
}
?startServer
installUtilities(installIE=TRUE, installChrome=TRUE)
rm(list = ls())


