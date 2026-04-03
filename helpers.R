library(tidyr)
library(data.table)
library(arrow)
library(dplyr)
library(lubridate)
library(stringr)

## Load data
mth<- c("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")
var <- c("rango_edad", "tipo_establecimiento", "region")

getdata <- function(mth, var) {
  time_start <- Sys.time()
  myfile <-paste0(mth,".parquet")
  
  #get_table<- function(mth, var) {           
  res<- as.data.frame(read_parquet(myfile) |> select(NEstablecimiento, GlosaCausa, Menores_1, De_1_a_4, De_5_a_14, De_15_a_64, De_65_y_mas, fecha, GLOSATIPOESTABLECIMIENTO, NombreRegion, NombreComuna) |> 
    rename(tipo_establecimiento = GLOSATIPOESTABLECIMIENTO) |> 
    rename(region = NombreRegion) |> 
#   mutate(
#      period = format(as.Date(fecha), "%d/%m/%Y")) |> 
    pivot_longer(cols = c(Menores_1, De_1_a_4, De_5_a_14, De_15_a_64, De_65_y_mas),
                 names_to = "rango_edad",
                 values_to = "num") |> 
    filter(grepl("TOTAL", GlosaCausa)) |> 
    filter_out(GlosaCausa == "TOTAL DEMANDA") |>
    group_by_at(c("GlosaCausa", var)) |>
  summarise(n = sum(num, na.rm = TRUE)/1000)
  )
  
  time_end <- Sys.time()
  
  return(list(
    data = res,
    runtime = as.numeric(time_end - time_start)
  ))
}
