
<p align="left">
  <img src="https://github.com/brendan-newlon/sourceR/blob/main/logos/sourceR_logo_card1.png" width="60%" alt="sourcer logo. sourceR: R packages and script sources will magically appear">
</p>
   
   
## sourceR
R package for sourcing, searching, and editing your project's .R scripts and other resources

**Most enchanting features:**

- Summon and source any .R files in your project /R directory or subdirectories with ```sourceR()``` or, if you're a ghoul, ```sourceR("path/to/wherever/ghouls/keep/their/r/scripts", exclude=c("spooky_noise.R", "big_red_button.R", "south_tower.R"))```
- Conjure, install, and load packages in one line, eg ```source_packages(c("dplyr", "stringr", "readr"))```
- Portend how much RAM to allocate automatically based on available system resources using ```source_ram()``` or specify configurations like ```source_ram(only_free=TRUE)``` or ```source_ram(percent_of_total=20)```
- Magically configure the working directory with ```source_wd("myScript.Rmd")```

**What the future may hold...** (*ie. stay tuned; in development*) 
- Get source_packages() to handle install_github() and similar for repo links
- Find/replace throughout all scripts in the /R directory or any subset
- Temporarily ```summon()``` related scripts together into an .Rmd to easily edit or debug a workflow, then ```cast()``` the improved versions back to their original, separate script files or ```banish()``` the temporarily summoned document medly.


# How to use this package:

1. ```install_github("https://github.com/brendan-newlon/sourceR")``` Alternately, copy MyProjectTemplate.zip or manually copy the script files from sourceR's /R directory into the /R directory of your project's root folder.
2. Copy the code below to the top of your project script (and update the variable this_file to your script's filename). Scripts within your project's /R directory will source/run automatically.
```r 
this_file = "sourceR.Rmd" ; source(file.path("R","sourceR.R")); sourceR(); source_ram(); source_wd(this_file); 
source_packages(c("dplyr", "readr", "stringr", "tidyr", "lubridate", "magrittr", "utf8"))
```
3. Add or remove package names from the ```source_packages()``` vector above to suit the needs of your project.

# Feeling lazy? 

1. Download [MyProjectTemplate.zip](https://github.com/brendan-newlon/sourceR/blob/main/MyProjectTemplate.zip "Hufflepuff!"). Copy the unzipped folder as a template for new projects with sourceR built in to load the scripts in your /R directory automatically.
