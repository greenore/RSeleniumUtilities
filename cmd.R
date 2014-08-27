
getPath()
javaPath <- getJavaPath()
checkEnvVar(pathVar=installPath)
checkEnvVar(pathVar=javaPath)
setEnvVar(pathToVar=paste0(installPath, ';"', javaPath,'"'))
copyUtilities(installIE=TRUE, installChrome=TRUE)

rm(list = ls())
