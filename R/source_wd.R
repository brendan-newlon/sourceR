#' Configure the working directory
#' 
#' Ensure the project root is set up correctly and create a global variable wd to represent the project root as working directory.
#'
#' @param this_file The name of the script calling the function. This uses here::i_am to set the project root correctly.
#'
#' @return
#' @export
#'
#' @examples
source_wd = function(this_file) {
  source_packages("here",
                  show_loaded_packages = F,
                  show_package_processes = F)
  
  # suppressMessages(here::i_am(file.path("..", this_file) ))
  suppressMessages(here::i_am(this_file ))
  
  cat("Setting working directory to", here(),"\n")
  cat("Assigning working directory to the global variable 'wd'")
  # here() %T>% assign("wd", ., envir = .GlobalEnv)
  assign("wd", here(), envir = .GlobalEnv)
  setwd(wd)
}
