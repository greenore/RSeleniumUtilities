#' @export
## Overall Meta functions
# Get System information
sysInfo <- function(){
  sys.info <- list()
  sys.info$sys_name <- Sys.info()["sysname"][[1]]
  sys.info$usr_name <- Sys.info()["user"][[1]]
  sys.info$bit_format <- Sys.info()["machine"][[1]]
  
  sys.info
}

#' @export
## Appending to a file on unix systems
appendFileUnix <- function(input_txt, file_path){
  
  # If the last line is not empty, add line
  file_content <- readLines(file_path)
  if(file_content[length(file_content)] != "") {
    system(paste0("echo ''", " >> ", file_path), intern=TRUE)
  }
  
  # Add text to file 
  if(!input_txt %in% file_content) {
    system(paste0("echo '", input_txt, "'", " >> ", file_path), intern=TRUE)
    cat(paste0("Succesfully added:\n", input_txt, "\nto:\n", file_path, "\n"))  
  } else {
    warning(paste0("\n\nDid not add:\n", input_txt, "\nto:\n", file_path, "\n\nText already exists...\n"))
  }
}

#' @export
## Environmental Variables
getEnvVar <- function(env_var_name="Path"){
  sys.info <- sysInfo()
  
  if(sys.info$sys_name == "Windows") {
    env_var_name <- paste0(env_var_name, "=")
    env_var <- shell('set Path', intern=TRUE)
    env_var <- env_var[grep(env_var_name, env_var)]
    env_var <- unlist(strsplit(env_var, ";"))
    env_var <- gsub(pattern=env_var_name, replacement="", x=env_var)
    env_var <- gsub(pattern="[\\]", replacement="/", x=env_var)
  }
  
  if(sys.info$sys_name == "Linux") {
    if(env_var_name=="Path") {env_var_name <- toupper(env_var_name)}
    env_var_name <- paste0("$", env_var_name)
    env_var <- system(paste0('echo ', env_var_name), intern=TRUE)
    env_var <- unlist(strsplit(env_var, ":"))
  }
  
  env_var
}

#' @export
checkEnvVar <- function(path_var){
  env_var <- getEnvVar()
  
  min_env_var <- tolower(gsub(pattern="/", replacement="", x=env_var))
  min_path_var <- tolower(gsub(pattern="/", replacement="", x=path_var))
  
  if(min_path_var %in% min_env_var) {
#     message(paste0("The path: ", path_var, " is correctly added to the system environment..."))
    TRUE
  } else {
    warning(paste0("The path: ", path_var, " is not found in the system environment...\n",
                   "execute: setPathVar() or add the variable manually to the path...\n",
                   "NOTE: It might be that you need to restart the system for changes to take effect..."))
    FALSE
  }
}

#' @export
## Setting Path variables
setEnvVar <- function(path_to_var){
  sys.info <- sysInfo() 
  
  if(sys.info$sys_name == "Windows") {
    shell(paste0('C:/Windows/System32/setx.exe Path ', path_to_var), intern=TRUE)
    message(paste0(path_to_var, "\nadded to the Windows environment path...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
  
  if(sys.info$sys_name == "Linux") {
    profile_path <<- paste0("/home/", sys.info$usr_name, "/.profile")
    appendFileUnix('# Add Selenium to the PATH Environment', profile_path)
    appendFileUnix(paste0("export PATH=$PATH:", path_to_var), profile_path)
    message(paste0("export PATH=$PATH:", path_to_var, "\nadded to the .profile file...\n"))
    message("It might be necessary to reboot the Computer in order for the changes to take effect!!!")
  }
}

## Get Java path information
#' @export
getJavaPath <- function(){
  sys.info <- sysInfo() 
  
  if(sys.info$sys_name == "Windows") {
    java_path <- "C:/Program Files/Java"
  }
  
  java_dir_content <- list.files(java_path)[grep("jdk", list.files(java_path))]
  num <- as.numeric(gsub("[[:alpha:][:punct:]]{1, }", "", java_dir_content))
  newest_version <- java_dir_content[num %in% max(num)]
  
  paste0(java_path, "/", newest_version, "bin/")
}

#' @export
# Get the path information
getPath <- function(){
  sys.info <- sysInfo()
  bin.path <- list()
  
  # System information
  bin.path$path_to_binaries <- file.path(find.package("RSeleniumUtilities"))
  bin.path$path_to_selenium_server <- paste0(file.path(find.package("RSelenium")), '/bin')
  
  if(sys.info$sys_name == "Windows") {
    bin.path$install_path <- paste0("C:/Users/", sys.info$usr_name, "/AppData/Local/Selenium/")
    bin.path$chrome_path <- paste0(bin.path$path_to_binaries, "/bin/", sys.info$bit_format, "Chrome", sys.info$sys_name, "/chromedriver.exe")
    bin.path$ie_path <- paste0(bin.path$path_to_binaries, "/bin/", sys.info$bit_format, "InternetExplorer", sys.info$sys_name, "/IEDriverServer.exe")
  }
  
  if(sys.info$sys_name == "Linux") {
    bin.path$install_path <- paste0("/home/", sys.info$usr_name, "/.selenium")
    bin.path$chrome_path <- paste0(bin.path$path_to_binaries, "/bin/", sys.info$bit_format, "Chrome", sys.info$sys_name, "/chromedriver")
  }
  
  bin.path$selenium_path <- paste0(bin.path$path_to_binaries, "/bin/seleniumJar/selenium-server-standalone.jar")
  bin.path$java_path <- suppressWarnings(getJavaPath())
  
  bin.path
}

#' @export
## Copying of the Selenium utilities 
copySelenium <- function(){
  sys.info <- sysInfo() 
  bin.path <- getPath()
  
  # Remove and create hidden selenium directory
  unlink(file.path(bin.path$install_path), recursive=TRUE, force=TRUE)
  dir.create(bin.path$install_path)
  
  # Copy files
  file.copy(from=bin.path$chrome_path, to=bin.path$install_path, overwrite=TRUE,
            recursive=TRUE)
  if(sys.info$sys_name == "Windows") {
    file.copy(from=bin.path$ie_path, to=bin.path$install_path, overwrite=TRUE,
              recursive=TRUE)
  }
  
  if(sys.info$sys_name == "Linux") {
    # Make file executable
    system(paste0("chmod +x ", paste0(bin.path$install_path, "/chromedriver")))
  }
  
  # Copy selenium server jar to the RSelenium bin folder
  file.copy(from=bin.path$selenium_path, to=bin.path$path_to_selenium_server,
            overwrite=TRUE, recursive=TRUE)
}

#' @export
# Check all necessary path for Selenium to run and copy if necessary the missing binaries
checkSeleniumPath <- function(){
  bin.path <- getPath()
  
  # Check if selenium and java are in the environment path
  check_cond <- checkEnvVar(path_var=bin.path$install_path) & checkEnvVar(path_var=bin.path$java_path)
  if(check_cond == FALSE){
    setEnvVar(path_to_var=paste0(bin.path$install_path, ";'", bin.path$java_path,"'"))
  }
  
  # Check if selenium the selenium server file is present
  check_cond <- file.exists(paste0(bin.path$path_to_selenium_server, "/selenium-server-standalone.jar"))
  if(check_cond==FALSE){
    copySelenium()
  }
  
  message("Selenium is correctly installed...")
}
