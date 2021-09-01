
<p align="left">
  <img src="https://github.com/brendan-newlon/sourceR/blob/main/sourceR_logo_card1.png" width="60%" alt="sourcer logo. sourceR: R packages and script sources will magically appear">
</p>
   
   
# sourceR
R package for sourcing, searching, and editing your project's .R scripts and other resources

- Summon and source any .R files in your project /R directory or subdirectories with ```sourceR()```
- Conjure, install, and load packages in one line, eg ```source_packages(c("dplyr", "stringr", "readr"))```
- Portend how much RAM to allocate automatically based on available system resources using ```source_ram(only_free=TRUE)``` or ```source_ram(percent_of_total=20)```
- Magically configure the working directory

What it's future holds... (ie. stay tuned; in development) 
- find/replace throughout all scripts in the /R directory or any subset
- temporarily gather related scripts together into an .Rmd to easily edit or debug a workflow, then cast the improved versions back to their original, separate script files


How to use this package:

1. If you aren't loading sourceR with library() or install_github(), copy the script files from sourceR's /R directory into the /R directory of your project's root folder.
2. Copy the code below to the top of your project script.
3. Update the variable this_file to your script's filename. 
4. Save additional scripts anywhere within your project's /R directory to source them all automatically.
5. Add or remove package names from example source_packages to suit the needs of your project.


```{r setup, include=FALSE}
this_file = "sourceR.Rmd" ; source(file.path("R","sourceR.R")); sourceR(); source_ram(); source_wd(this_file); 
source_packages(c("dplyr", "readr", "stringr", "tidyr", "lubridate", "magrittr", "utf8", "readtext", "R.utils", "devtools", "rlang", "data.table", "xlsx", "keyring", "SPARQL", "httr", "jsonlite", "tidyverse"))
```
