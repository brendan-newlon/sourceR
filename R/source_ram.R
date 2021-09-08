#' Allocate system RAM
#'
#' Allocate a portion of system RAM for R and/or Java to use.
#'
#' @param only_free If TRUE, only allocate the system's currently free memory.
#' @param percent_of_total An integer of what percent of memory to allocate, which also serves as an upper limit to allocating free ram.
#' @param mem_unit Currently assumes available memory is measured in GB -- More options TBD in a future version.
#' @param round_up If TRUE, it rounds decimals .5 and above up to the next whole number of GBs, otherwise rounds down.
#'
#' @return Sets memory use option.
#' @export
#'
#'
#'
source_ram = function(only_free = T, percent_of_total = 25, mem_unit = "GiB", round_up = T) {
  if(round_up){rounding = base::round } else {rounding = base::floor }
  if(isTRUE(mem_unit == "GiB")){
    mem_unit_multiplier = 1024
  }
  if(isTRUE(mem_unit == "MiB")){
    mem_unit_multiplier = .001024
  }
  source_packages("memuse", show_loaded_packages = F, show_package_processes = F)
  mem = memuse::Sys.meminfo()
  if(only_free){
    free_ram =  rounding(as.numeric(gsub("[ a-zA-Z]" , "", as.character(mem$freeram)) ) )
    free = free_ram
    ## What if the free memory rounds down to zero?
    if(isTRUE(free > 0)){
      free = free * mem_unit_multiplier
      percent_limit = as.numeric(gsub(paste0(" ",mem_unit), "", mem$totalram)) * (percent_of_total/100) * mem_unit_multiplier
      if(free > percent_limit){
        free = percent_limit
      }
      free_ram = free
    } else  {
      free_ram = signif(as.numeric(gsub(paste0(" ",mem_unit), "", mem$freeram)), digits = 1)
      free = free_ram * mem_unit_multiplier
    }
    free = paste0("-Xmx", free, "m")
    use_memory = free
    cat("Allocating", gsub("\\.[0-9]*", "",free_ram), "MiB","of RAM for Java heap space","\n" )
      } else {
    percent_ram = rounding(as.numeric(gsub(paste0(" ",mem_unit), "", mem$totalram)) * (percent_of_total/100))
    use = percent_ram * mem_unit_multiplier
    use_memory = paste0("-Xmx", use, "m")
    cat("Allocating", gsub("\\.[0-9]*", "",use), "MiB","of RAM for Java heap space","\n"  )
  }
  #--------
  options(java.parameters = c("-XX:+UseConcMarkSweepGC", use_memory))
}
