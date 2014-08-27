#' @export

# Overall Meta functions
#-----------------------

# Get System information
sysInfo <- function(){
  sysName <<- Sys.info()["sysname"][[1]]
  usrName <<- Sys.info()["user"][[1]]
  bitFormat <<- Sys.info()["machine"][[1]]  
}

#' @export
# Find partial text with the help of regual expressions
findPartialTxt <- function(inputVector, partialTxt, regex="[[:alnum:][:punct:]]{1, }"){
  expr <- paste(partialTxt, regex, sep = "")
  output <- regmatches(inputVector, regexpr(expr, inputVector))
  output
}

#' @export
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

#' @export
# Environmental Variables
#-------------------------
getEnvVar <- function(envVarName="Path"){
  sysInfo()
  
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

#' @export
checkEnvVar <- function(pathVar){
  envVar <- getEnvVar()

  minEnvVar <- tolower(gsub(pattern="/", replacement="", x=envVar))
  minPathVar <- tolower(gsub(pattern="/", replacement="", x=pathVar))
  
  if(minPathVar %in% minEnvVar) {
    message(paste0("The path: ", pathVar, " is correctly added to the system environment..."))
    TRUE
  } else {
    warning(paste0("The path: ", pathVar, " is not found in the system environment...\n",
                   "execute: setPathVar() or add the variable manually to the path...\n",
                   "NOTE: It might be that you need to restart the system for changes to take effect..."))
    FALSE
  }
}

#' @export
# Setting Path variables
#-----------------------
setEnvVar <- function(pathToVar){
  sysInfo()
  
  if(sysName == "Windows") {
    shell(paste0('C:/Windows/System32/setx.exe Path ', pathToVar), intern=TRUE)
    message(paste0(pathVar, "\nadded to the Windows environment path...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
  
  if(sysName == "Linux") {
    profilePath <<- paste0("/home/", usrName, "/.profile")
    appendFileUnix('# Add Selenium to the PATH Environment', profilePath)
    appendFileUnix(paste0("export PATH=$PATH:", pathVar), profilePath)
    message(paste0("export PATH=$PATH:", pathVar, "\nadded to the .profile file...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
}

#' @export
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
  file.copy(from=seleniumPath, to=pathToSeleniumServer)
}

#' @export
# Get path information
#---------------------
getPath <- function(){
  sysInfo()
  # System information
  pathToBinaries <<- file.path(find.package("RSeleniumUtilities"))
  pathToSeleniumServer <<- paste0(file.path(find.package("RSelenium")), '/bin')
  
  if(sysName == "Windows") {
    installPath <<- paste0("C:/Users/", usrName, "/AppData/Local/Selenium/")
    chromePath <<- paste0(pathToBinaries, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver.exe")
    iePath <<- paste0(pathToBinaries, "/bin/", bitFormat, "InternetExplorer", sysName, "/IEDriverServer.exe")
  }
  
  if(sysName == "Linux") {
    installPath <<- paste0("/home/", usrName, "/.selenium")
    chromePath <<- paste0(pathToBinaries, "/bin/", bitFormat, "Chrome", sysName, "/chromedriver")
  }
  
  seleniumPath <<- paste0(pathToBinaries, "/bin/seleniumJar/selenium-server-standalone.jar")
}

#' @export
getJavaPath <- function(){
  sysInfo()
  
  if(sysName == "Windows") {
    javaPath <- "C:/Program Files/Java"
  }
    
  javaDirContent <- list.files(javaPath)[grep("jdk", list.files(javaPath))]
  num <- as.numeric(gsub("[[:alpha:][:punct:]]{1, }", "", javaDirContent))
  newestVersion <- javaDirContent[num %in% max(num)]
  
  paste0(javaPath, "/", newestVersion, "/bin/")
}
