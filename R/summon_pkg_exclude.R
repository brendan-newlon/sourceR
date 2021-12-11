## unpack_pkg()

## Suppose all the source scripts of a package are stored in the installed package /R directory, eg as "renv.rdb" 
## Suppose the directory is: "C:\\Users\\brend\\OneDrive\\Documents\\R\\win-library\\4.0\\renv\\R"
library(magrittr)
library(tidyverse) ; library(dplyr) ; library(lubridate)
# library(magrittr)

`%>%` = magrittr::`%>%`
as.df = function(x){as.data.frame(x,strings.as.factors = F)}

the_pkg = "renv"  ## some installed package



###################################### temp


summon_pkg = function(
  the_pkg,
  summon_as_filetype = "R",
  open_summoned = T # FALSE might serve archiving purposes for sets of functions as they existed at a time
) {
  # the_pkg = "renv"  ## some installed package
  the_dir = pkgload::inst(the_pkg)  ## finds the installed package directory
  ## ------------------------------- Dependencies? 
  dep = readLines(file.path(the_dir,"DESCRIPTION")) %>% 
    as.df() %>% 
    setNames("x") 
  dep = dep [grepl("^Imports|^Suggests",dep$x),]
  imports = dep[[1]] %>% gsub("Imports: |,$", "",.) %>% str_split(", ") %>% .[[1]] %>% paste0("require(",.,")")  %>% paste(collapse = "\n")
  suggests = dep[[2]]%>% gsub("Suggests: |,$", "",.)%>% str_split(", ")%>% .[[1]] %>% paste0("# require(",.,")") %>% paste(collapse = "\n")
    
  
  
  
  e = environment()
  lazyLoad(filebase = paste0(the_dir, "\\R\\", the_pkg), envir = e) %>% invisible()
  the_fns = ls(e)
  fns_df = the_fns %>% as.data.frame(strings.as.factors = F)
  fns_df$obj_class = lapply(fns_df$the_fns, function(x){class(get(x))})  # what kind of thing is it? function? environment?
  
  df = fns_df %>% 
    setNames(c("x", "obj_class")) %>% 
    mutate(is_f = obj_class == "function") %>% mutate_all(as.character)
  df = df [df$is_f == "TRUE",]  ## only the functions

  ## Add a column with the full function definition  
  for (i in seq_along(df$x)){
    f = capture.output(eval(parse(text = paste0("`",df$x[i],"`"))) )
    if(length(f)>2){
    f = f[1:(length(f)-2)]
    }
    f = f %>% paste(collapse = " \n ")
    fn = paste0(
          paste0("`",df$x[i],"`") , " = " , f
        )
    df$def[i] = fn
  }
  
  df = df %>% 
    select(x, def) %>% 
    setNames(c("fn_name", "fn_def"))
  
  # How to divide the sections
  if(isTRUE(summon_as_filetype == "Rmd")){
    block_dividers = c("```{r}\n\n", "```\n\n")
    unblocked_comment_prefix = ""
  } else {
    block_dividers = c("##____________________________________________\n", "##____________________________________________\n##############################################\n\n")
    unblocked_comment_prefix = "## "
  }
  
  # Create the blank summoned file
  summon_timestamp = capture.output( invisible(paste0(timestamp()) ) )
  summon_time =   gsub(" ","_",gsub("\"|\\[1\\] |-|:","",capture.output(now())))
  summoned = paste0("summoned_",summon_time,".", summon_as_filetype) ;
  invisible(capture.output(file.create(summoned))) ;
  write_file(
    file = summoned, 
    x = paste0(
       "\n",
       summon_timestamp, "\n\n",
       unblocked_comment_prefix, "summoned_",summon_time, "\n",
       unblocked_comment_prefix, "~~~*%$#&!%$*#@!&^%!#*!*~~~", "\n##############################################\n\n" ,
       block_dividers[1],
       "## ", "Imports: ", "\n", 
       imports,"\n\n",  
       "## ", "Suggests: ", "\n", 
       suggests,"\n",
       block_dividers[2],
       unblocked_comment_prefix, "~~~*%$#&!%$*#@!&^%!#*!*~~~", "\n##############################################\n\n"), append = F)
  
  # Summon the source files into the summoned file
  for(i in seq_along(df$fn_name)){
    summoned_block = paste0(
      unblocked_comment_prefix, 
      df$name[i]
      , "\n\n",
      block_dividers[1],
      unblocked_comment_prefix, 
      paste0(df$fn_name[i]), 
      "\n\n",
      df$fn_def[i] ,
      "\n",
      block_dividers[2]
    )
    write_file(file = summoned, summoned_block, append = TRUE)
  }
  
  if(open_summoned){file.edit(summoned, editor = "Rstudio")}
}


####################################


## Get the source of the package
the_dir = pkgload::inst(the_pkg)
e = new.env()
lazyLoad(filebase = paste0(the_dir, "\\R\\", the_pkg), envir = e) %>% invisible()
ls(e)

e$ask


## enchant / modify functions as needed 

e$trogdor = function (){"burninated!"}


## Store the modified functions as lazy-loadable r databases
if(!dir.exists("enchanted_pkgs")){dir.create("enchanted_pkgs")}
if(!dir.exists(file.path("enchanted_pkgs", the_pkg))){dir.create(file.path("enchanted_pkgs", the_pkg))}
tools:::makeLazyLoadDB(e, file.path("enchanted_pkgs",the_pkg, paste0("enchanted_", the_pkg) ) )



###################### restart R session before continuing ###################
###################### restart R session before continuing ###################
###################### restart R session before continuing ###################
###################### restart R session before continuing ###################



## Load all the enchanted packages
enchanted_pkg_dirs = list.dirs(file.path("enchanted_pkgs"), recursive = F, full.names = F)
enchanted_pkgs = new.env()
for(i in seq_along(enchanted_pkg_dirs)){
  pkg_name = enchanted_pkg_dirs[i]
  assign(pkg_name, new.env(parent = enchanted_pkgs), envir = enchanted_pkgs)
  e = new.env()
  lazyLoad(filebase = file.path("enchanted_pkgs", enchanted_pkg_dirs[i], paste0("enchanted_",enchanted_pkg_dirs[i]) ), envir = e) %>% invisible()
  assign(pkg_name, e, envir = enchanted_pkgs)
  }

# ls(enchanted_pkgs$renv)
# 
# enchanted_pkgs$renv$ask  ## show the function source
# enchanted_pkgs$renv$trogdor()  ## do the function
# 
# get("trogdor")  ## doesn't find it 
# get("trogdor", envir = enchanted_pkgs$renv)
# 
# s = new.env(parent = emptyenv())
# assign("enchanted_pkgs", enchanted_pkgs, envir = s)
# 
# get("trogdor", envir = s$enchanted_pkgs$renv)


# e = ls()
# enchanted_pkg_dirs=NULL
# enchanted_pkgs = ls()
# renv = ls()
# rm(e,enchanted_pkg_dirs,enchanged_pkgs, enchanted_pkgs,renv)

# summon_pkg("renv")
