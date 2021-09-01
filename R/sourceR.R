#' Automagically source scripts
#'
#' sourceR helps to manage project code by sourcing scripts selectively,
#' recursively. By default it will load any .R file in the project's /R
#' directory or subdirectories. 
#' 
#' @param source_dir The relative name of the directory within your project
#'   folder containing scripts to source.
#' @param include_rmd TRUE to also source .Rmd files.
#' @param exclude_dirs A character string or vector of directories to exclude
#'   from automatic sourcing.
#' @param exclude_files A character string or vector of files that should not be
#'   sourced.
#' @param recursive TRUE to source files in the source_dir and any directories
#'   within it, and so on.
#' @param exclude_marked_exclude TRUE to avoid sourcing any script with a
#'   filename with an "_exclude" suffex, eg. "IncompleteScript_exclude.R"
#' @param exclude_sourceR TRUE to skip reloading this function from source
#'   whenever the function is called.
#' @param echo_files_sourced TRUE to echo the list of files sourced to
#'   output/console.
#'
#' @return
#' @export
#'
#' @examples
sourceR = function(source_dir = "R",
                   include_rmd = F,
                   exclude_dirs = "",
                   exclude_files = "",
                   recursive = T, 
                   exclude_marked_exclude = T, 
                   exclude_sourceR = T,
                   echo_files_sourced = T
                   ) {
  sourcing_directory = file.path(source_dir)
  R_scripts = list.files(
    path = sourcing_directory,
    all.files = T,
    include.dirs = F,
    pattern = ".R$",
    recursive = recursive
  )
  rmd_scripts = list.files(
    path = sourcing_directory,
    all.files = T,
    include.dirs = F,
    pattern = ".Rmd$"
  )
  if (include_rmd) {
    sources = append(R_scripts, rmd_scripts)
  } else {
    sources = R_scripts
  }
  if (all(exclude_files != "")) {
    for (s in seq_along(exclude_files)) {
      sources = sources[!grepl(exclude_files[[s]], sources)]
    }
  }
  if(exclude_marked_exclude){sources = sources[!grepl("_exclude.[^.]*$", sources)]}
  if(exclude_sourceR){sources = sources[!grepl("^sourceR.R$", sources)]}
  for (i in seq_along(sources)) {
    if(echo_files_sourced){
    cat("Sourcing script:", sources[i], "\n")}
    suppressMessages(
      source(
      file.path(sourcing_directory, sources[i]),
      local = knitr::knit_global(),
      encoding = "UTF-8"
    )
    )
  }
}
## eg.
# sourceR("R",exclude_files=c("sourceR.R"))