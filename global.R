# global.R

# nicehash API build
library(httr)
library(dplyr)

addr <- "3EhPgAwWq9n6KpQV23vXbvxrarAPphNyey"
niceApi <- "https://api.nicehash.com/api"

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
