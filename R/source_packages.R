#' Install and load multiple packages at once
#'
#' @param pkgs A character vector of package names to install as needed and load to the environment.
#' @param show_loaded_packages If TRUE, echo the list of packages loaded.
#' @param show_package_processes If TRUE, echo messages about the installation processes.
#' @param lib
#' @param repos defaults to 'http://cran.us.r-project.org'
#'
#' @return Installs and loads the packages.
#' @export
#'

source_packages = function(pkgs, show_loaded_packages = F, show_package_processes = F, lib = .libPaths()[[1]], repos='http://cran.us.r-project.org') {
  new.pkgs = pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if (length(new.pkgs))

    if(show_package_processes){
      install.packages(new.pkgs, dependencies = T, lib = lib, repos=repos)
    } else {
      suppressMessages(suppressPackageStartupMessages( install.packages(new.pkgs, dependencies = T, lib = lib, repos=repos) ))
    }

  if (show_loaded_packages) {
    cat("Packages loaded:", "\n")
    sapply(pkgs, require, character.only = T)
  } else{
    invisible(sapply(pkgs, require, character.only = T))
  } # end of: don't show loaded pkgs


}
