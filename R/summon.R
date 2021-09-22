summon = function(
                   # --- Files --- #
                   files = "",
                   file_pattern = ".R$",
                   include_rmd = T,
                   exclude_files = "",
                   exclude_marked_exclude = T,
                   exclude_summon = T,
                   # --- Files in directory etc --- #
                   directory = "R",
                   all_in_dir = F,
                   recursive = T,
                   exclude_dirs = "",
                   # --- Functions --- #
                   functions = "", # feature request !!! (?)
                   # could we look back in the session / call stack to find when each function was loaded, and from where, and use that to pull in the text of the function?
                   # for functions in loaded packages, can we get that from wherever defined?
                   # --- What to do ? --- #
                   summon_as_filetype = "Rmd",
                   open_summoned = T # FALSE might serve archiving purposes for sets of functions as they existed at a time

) {


## --- testing ---
  # files = ""
  # file_pattern = ".R$"
  # include_rmd = T
  # exclude_files = ""
  # exclude_marked_exclude = T
  # exclude_summon = T
  # # --- Files in directory etc --- #
  # directory = "R"
  # all_in_dir = F
  # recursive = T
  # exclude_dirs = ""
  # # --- Functions --- #
  # functions = ""
  # summon_as_filetype = "Rmd"
  # open_summoned =T


# files = c("happy.txt", "great.R", "ok.Rmd")
# files = ""
# file_pattern = ".R$"

  ## What to summon _______________
  if(all(files != "")){
    file_pattern = paste0("^", paste(files, collapse = "$|^"), "$")
  }  else {
    if (include_rmd) {file_pattern = paste0(file_pattern,"|.Rmd$") }
  }
  sources = list.files(path = directory, all.files = T, include.dirs = F, pattern = file_pattern, recursive = recursive)

  ## What not to summon ________________
  if (all(exclude_files != "")) {
    for (s in seq_along(exclude_files)) {
      sources = sources[!grepl(exclude_files[[s]], sources)]
    }
  }
  if(exclude_marked_exclude){sources = sources[!grepl("_exclude.[^.]*$", sources)]}
  if(exclude_summon){sources = sources[!grepl("^summon.R$", sources)]}

  ## Summoning ______________
  source_file_content = readtext::readtext(file.path(directory, sources) ) %>% suppressWarnings()

  # How to divide the sections
  if(isTRUE(summon_as_filetype == "Rmd")){
    block_dividers = c("```{r}\n\n", "```\n\n")
    unblocked_comment_prefix = ""
  } else {
    block_dividers = c("##____________________________________________\n", "##____________________________________________\n##############################################\n\n")
    unblocked_comment_prefix = "# "
  }

  # Create the blank summoned file
  summon_timestamp = capture.output( invisible(paste0(timestamp()) ) )
  summon_time = capture.output(now()) %>% gsub("\"|\\[1\\] |-|:","",.) %>% gsub(" ","_",.)
  summoned = paste0("summoned_",summon_time,".", summon_as_filetype) ;
  invisible(capture.output(file.create(summoned))) ;
  write_file(file = summoned, x = paste0("\n",
                                         summon_timestamp, "\n\n",
                                         unblocked_comment_prefix, "summoned_",summon_time, "\n",
                                         unblocked_comment_prefix, "~~~*%$#&!%$*#@!&^%!#*!*~~~", "\n##############################################\n\n"), append = F)



  # Summon the source files into the summoned file
  for(i in seq_along(source_file_content$doc_id)){
    summoned_block = paste0(
      unblocked_comment_prefix, source_file_content$doc_id[[i]], "\n\n",
      block_dividers[1],
      "#", unblocked_comment_prefix, paste0(source_file_content$doc_id[[i]],"_summoned_",summon_time), "\n\n",
      source_file_content$text[[i]], "\n",
      block_dividers[2]
      )
    write_file(file = summoned, summoned_block, append = TRUE)
  }



  ## Add the casting/banishing block to the end
  banish_cast_block = paste0(
    unblocked_comment_prefix, "Use banish() to close and delete this file or cast() to overwrite the summoned files with edits made to their corresponding blocks above.",
    "\n\n",
    block_dividers[1],
    unblocked_comment_prefix, "~~~*%$#&!%$*#@!&^%!#*!*~~~", "\n\n",
    "# banish(\"","summoned_",summon_time,"\")", "\n\n",

    "##__________________##", "\n",
    "## --- WARNING! --- ##", "\n",
    "##__________________##", "\n\n",

    "## If you use the function below, the following files will be permanently overwritten:", "\n\t",
    paste("## ",source_file_content$doc_id, collapse = "\n\t"), "\n\n",

    "## Proceed if you dare.", "\n\n",
    # "# cast(\"","summoned_",summon_time,"\")", "\n",
    "# cast(","\n#\t", "c(", "\n#\t",  paste0("\""),
      paste(source_file_content$doc_id,"_summoned_",summon_time, collapse = "\",\n#\t\"", sep = ""),
    paste0("\"\n#\t)"), "\n#"," )", "\n",
    "\n",
    block_dividers[2]
  )
  # cat(banish_cast_block)
  write_file(file = summoned, banish_cast_block, append = TRUE)

  if(open_summoned){file.edit(summoned)}
}
## eg.
# summon(directory = "R", summon_as_filetype = "R")
