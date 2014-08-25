# Get System information
#-----------------------
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

# Appending to a file on unix systems
#------------------------------------
appendFileUnix <- function(inputTxt, filePath){
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



# Environmental Variables
#-------------------------
getEnvVar <- function(envVarName="Path"){
  
  if(sysName == "Windows") {
    envVarName <- paste0(envVarName, "=")
    envVar <- shell('set Path', intern=TRUE)
    envVar <- envVar[grep(envVarName, envVar)]
    envVar <- unlist(strsplit(envVar, ";"))
    envVar <- gsub(pattern=envVarName, replacement="", x=envVar)
    envVar <- gsub(pattern="[\\]", replacement="/", x=envVar)
  }
  
  if(sysName == "Linux") {
    if(envVarName=="Path") {envVarName <- toupper(envVarName)}
    envVarName <- paste0("$", envVarName)
    envVar <- system(paste0('echo ', envVarName), intern=TRUE)
    envVar <- unlist(strsplit(envVar, ":"))
  }
  
  envVar
}

checkEnvVar <- function(pathVar){
  envVar <- getEnvVar()

  envVar <- tolower(gsub(pattern="/", replacement="", x=envVar))
  pathVar <- tolower(gsub(pattern="/", replacement="", x=pathVar))
  
  if(pathVar %in% envVar) {
    message("The path to Selenium is correctly added to the system environment variables...")
    TRUE
  } else {
    warning(paste0("\n\nSelenium is not found in the path variable...\n",
                   "execute: setPath() or add the variable manually to the path...\n",
                   "NOTE: It might be that you need to restart the system for changes to take effect..."))
    FALSE
  }
  
}

# Setting Path variables
#-----------------------
setPath <- function(installPath){
  
  if(sysName == "Windows") {
    shell(paste0("C:/Windows/System32/setx.exe PATH ", installPath), intern=TRUE)
    message(paste0(installPath, "\nadded to the Windows environment path...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
  
  if(sysName == "Linux") {
    profilePath <<- paste0("/home/", usrName, "/.profile")
    appendFileUnix('# Add Selenium to the PATH Environment', profilePath)
    appendFileUnix(paste0("export PATH=$PATH:", installPath), profilePath)
    message(paste0("export PATH=$PATH:", installPath, "\nadded to the .profile file...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
}


# Copying of the Selenium utilities 
#----------------------------------
copyUtilities <- function(installIE=TRUE, installChrome=TRUE){
  sysInfo()
  # Remove and create hidden selenium directory
  unlink(file.path(installPath), recursive=TRUE, force=TRUE)
  dir.create(installPath)
  
  # Copy files
  file.copy(from=chromePath, to=installPath)
  if(sysName == "Windows") {
    file.copy(from=iePath, to=installPath)
  }
  
  if(sysName == "Linux") {
    # Make file executable
    system(paste0("chmod +x ", paste0(installPath, "/chromedriver")))
  }
  
  # Copy selenium server jar to the RSelenium bin folder
  file.copy(from=seleniumPath, to=RSeleniumBinPath)
}





checkEnvVar(pathVar=installPath)

# java in the path?
# C:\Program Files\Java

# The Selenium Server was started with 
# -Dwebdriver.chrome.driver=c:\path\to\your\chromedriver.exe
sysInfo()
getPath()
setPath(installPath=installPath)

library(basleR)
identifier <- ""
regex <- "[[:alnum:]]{1, }"
C:\Program Files\Java
expr <- paste(identifier, regex, sep = "")
output <- regmatches(input, regexpr(expr, input))

C:/Program Files/Java/jdk1.7.0_21/bin
cutTxt

setPath()
checkPath()
copyUtilities(installIE=TRUE, installChrome=TRUE)

rm(list = ls())

paste0("chmod +x ", )
