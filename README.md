# sourceR
R package for sourcing, searching, and editing .R files


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
