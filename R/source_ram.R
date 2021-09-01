#' Allocate system RAM
#' 
#' Allocate a portion of system RAM for R and/or Java to use.
#'
#' @param only_free If TRUE, only allocate the system's currently free memory.
#' @param percent_of_total An integer of what percent of memory to allocate, which also serves as an upper limit to allocating free ram.
#' @param mem_unit Currently assumes available memory is measured in GB -- More options TBD in a future version.
#' @param round_up If TRUE, it rounds decimals .5 and above up to the next whole number of GBs, otherwise rounds down.
#'
#' @return
#' @export
#'
#' @examples
source_ram = function(only_free = T, percent_of_total = 20, mem_unit = "GiB", round_up = T) {
  
  if(round_up){rounding = base::round } else {rounding = base::floor } 
  
  if(isTRUE(mem_unit == "GiB")){ mem_unit_multiplier = 10240}
  
  source_packages("memuse", show_loaded_packages = F, show_package_processes = F)
  mem = memuse::Sys.meminfo()
  
  
  if(only_free){
    free_ram = mem$freeram %>% as.character() %>%  gsub(paste0(" ",mem_unit), "", .) %>% 
      as.numeric() %>% 
      rounding 
    
    free = free_ram
    ## What if the free memory rounds down to zero?
    if(isTRUE(free > 0)){

      
      # or what if it's greater than percent specified? 
      free = free * mem_unit_multiplier 
      percent_limit = mem$totalram %>% gsub(paste0(" ",mem_unit), "", .) %>% 
        as.numeric() %>% {. * (percent_of_total/100)}
      if(free > percent_limit){ free = percent_limit ; free_ram = free}
      free_ram = free
      
    } else       { 
      free_ram = mem$freeram %>% gsub(paste0(" ",mem_unit), "", .) %>% 
      as.numeric() %>% signif(digits = 1)
      free = free_ram * mem_unit_multiplier 
      }
    
    free = free %>% 
      paste0("-Xmx", ., "m")
    use_memory = free
    cat("Allocating", free_ram %>% gsub("\\.[0-9]*", "",.), mem_unit,"of RAM","\n" )
  } else {
    percent_ram = mem$totalram %>% gsub(paste0(" ",mem_unit), "", .) %>% 
      as.numeric() %>% {. * (percent_of_total/100)} %>% rounding
    
    use = percent_ram * mem_unit_multiplier 
    use_memory = use %>% 
      paste0("-Xmx", ., "m")
    cat("Allocating", percent_ram%>% gsub("\\.[0-9]*", "",.), mem_unit,"of RAM","\n" )
  }
  
  
  #--------
  options(java.parameters = c("-XX:+UseConcMarkSweepGC", use_memory))
}
