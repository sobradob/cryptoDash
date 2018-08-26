# global.R

# nicehash API build
library(httr)
library(dplyr)
library(ggplot2)
library(zoo)
library(googlesheets)
library(fontawesome)


# Nicehash API wrappers start here

addr <- "3EhPgAwWq9n6KpQV23vXbvxrarAPphNyey"
niceApi <- "https://api.nicehash.com/api"

niceHashWrapper <- function(addr, func){
  apiGet <- GET(niceApi,path = list("api"),query= list(method = func, addr = addr))
  warn_for_status(apiGet)
  print(apiGet$url)
  responseList <- content(apiGet,type = "application/json")
  return(responseList)
}

# tests
# niceHashWrapper(addr, "stats.provider")
# niceHashWrapper(addr, "stats.provider.workers")


algoTable <- data_frame( algo = 0:33, algoName = c("Scrypt",
                                                   "SHA256",
                                                   "ScryptNf",
                                                   "X11",
                                                   "X13",
                                                   "Keccak",
                                                   "X15",
                                                   "Nist5",
                                                   "NeoScrypt",
                                                   "Lyra2RE",
                                                   "WhirlpoolX",
                                                   "Qubit",
                                                   "Quark",
                                                   "Axiom",
                                                   "Lyra2REv2",
                                                   "ScryptJaneNf16",
                                                   "Blake256r8",
                                                   "Blake256r14",
                                                   "Blake256r8vnl",
                                                   "Hodl",
                                                   "DaggerHashimoto",
                                                   "Decred",
                                                   "CryptoNight",
                                                   "Lbry",
                                                   "Equihash",
                                                   "Pascal",
                                                   "X11Gost",
                                                   "Sia",
                                                   "Blake2s",
                                                   "Skunk",
                                                   "CryptoNightV7",
                                                   "CryptoNightHeavy",
                                                   "Lyra2Z",
                                                   "X16R"))


extractStatsNH <- function(responseList){
  statsLength <- length(responseList$result$stats)
  balance <- rep(NULL,statsLength)
  algo <- rep(NULL,statsLength)
  speed <- rep(NULL,statsLength)
  
  for(i in 1:statsLength){
    balance[i] <- as.numeric(responseList$result$stats[[i]]$balance)
    algo[i] <-  responseList$result$stats[[i]]$algo
    speed[i] <-  as.numeric(responseList$result$stats[[i]]$accepted_speed)
  } 
  responseDF <- data_frame(balance,algo,speed) %>% 
    left_join(., algoTable)
  return(responseDF)
}

# test<- niceHashWrapper(addr, "stats.provider")
# extractStatsNH(test)

#NANOPOOL API WRAPPERS START HERE

ethAddr <- "0x6700484b8751c701794b92d9ca04406853f085c4"
nanopoolApi <- "http://api.nanopool.org/v1/"
coin = "eth"
func= "user"

nanopoolWrapper <- function(addr,coin="eth",func){
  get_response <- GET(nanopoolApi,path = list("v1",coin,func,addr))
  warn_for_status(get_response)
  print(get_response$url)
  return(content(get_response))
}

# Google sheets starts here bro

readRDS("googlesheets_token.rds")

saveDataGs <- function(data, table) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}

loadDataGs <- function(data,table) {
  # Grab the Google Sheet
  sheet <- gs_title(table)
  # Read the data
  gs_read_csv(sheet)
}


 