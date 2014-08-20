.onLoad <- function(libname, pkgname) {
  # Load Java dependencies (all jars inside the java subfolder)
  .jpackage(name = pkgname, jars = "*")
}