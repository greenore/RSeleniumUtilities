## Helper Functions
#' @export
activateDropDown <- function(idButton, idMenu){
  element1 <- remDr$findElement(using = "id", value = idButton)
  element2 <- remDr$findElement(using = "id", value = idMenu)
  while(element2$isElementDisplayed() == F){element1$clickElement(); Sys.sleep(1)}
  element2
}

#' @export
getTxt <- function(element, split){
  elementList <- element$getElementText()
  txt <- unlist(strsplit(unlist(elementList), split = split, fixed = T))
  txt
}

#' @export
selectLinkTxt <- function(element, linkTxt){
  element2 <- element$findChildElement(using = "link text", value = linkTxt)
  element2$clickElement()
}

#' @export
# Minimize string distance (Damerau-Levenshtein Method)
minStringDistance <- function(targ_var, source_var, method='osa'){
  require(transformR)
  require(stringdist)
  
  targ_var <- changeUmlaute(tolower(targ_var))
  targ_var <- gsub(' ', '', targ_var)     # rm whitespace
  targ_var <- gsub('[.]', '', targ_var)   # rm dots
  
  source_var <- changeUmlaute(tolower(source_var))
  source_var <- gsub(' ', '', source_var)     # rm whitespace
  source_var <- gsub('[.]', '', source_var)   # rm dots
  
  char_dist <- stringdist(targ_var, source_var, method=method)
  char_dist
}

#' @export
# Select minimized string
selectMinString <- function(source_var, char_dist, select_first=FALSE){
  min_string <- source_var[char_dist %in% min(char_dist)]
  
  if(length(min_string) != 1){
    warning("There is more than 1 equivalent string to chose from...")
    
    if(select_first){
      min_string <- min_string[1]
      message(paste0("The first one was chosen: ", min_string))
    }
  }
  
  min_string
}

#' @export
# Stop scraping and write to profile
stopScraping <- function(stop_cond, csv_path, error_message, found_message=FALSE){
  if(stop_cond){
    df.merge <- read.csv2(csv_path, sep = ';', header = T, stringsAsFactors = F, encoding = 'latin1')[1, ]
    df.merge[, 1:length(df.merge)] <- error_message
    df.merge$ID <- ID
    write.table(df.merge, file=csv_path, append=T, col.names=F, row.names=F, sep=';')
    message(paste0("ERROR: ", error_message, "..."))
    try({stop}, silent=TRUE)
  } else {
    if(found_message){
      message("found item...")
    }
  }
}

#' @export
# Wait until the web element is present
waitForElement <- function(using, value, nTrials=100, untilItExists=TRUE,
                           give_message=TRUE){
  try({
    counter <- 0
    
    # Check until the element exists
    if(untilItExists == TRUE){
      elementExists <- FALSE
      
      while(counter < nTrials && elementExists == FALSE) {
        message("Waiting...")
        Sys.sleep(1)
        elementExists <- !is.null(try(remDr$findElement(using=using, value=value), silent = TRUE))
        counter <- sum(counter, 1)
      }
      
      if(elementExists == TRUE & give_message == TRUE){
        message(paste0("Success...\nThe element: '", value, "' is found..."))
      }
    }
    
    # Check until the element is gone
    if(untilItExists == FALSE){
      Sys.sleep(1)
      nElements <- length(remDr$findElements(using=using, value=value))
      
      while(counter < nTrials && nElements > 0) {
        if(give_message == TRUE){
          message(paste0("Waiting...", " Still ", nElements, " elements left"))
        }
        Sys.sleep(1)
        nElements <- length(remDr$findElements(using=using, value=value))
        counter <- sum(counter, 1)
      }
      
      if(nElements == 0 & give_message == TRUE){
        message(paste0("Success...\nThe element: '", value, "' is no longer present..."))
      }
    }
    
    if(counter == nTrials){
      stop(paste0("Time limit is up, i.e., more than ", nTrials, " trials have passed..."))
    }
  }, silent=TRUE)
}
