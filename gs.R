# testing google sheets

install.packages("googlesheets")
library(googlesheets)
library(dplyr)
library(httr)
gs_ls()
token <- gs_auth()
saveRDS(token, file = "googlesheets_token.rds")
nanopoolGs <- gs_title("nanopool")

currentUser<- nanopoolWrapper(addr = ethAddr,coin = "eth", func = "user") %>% 
  extract("data") %>% 
  unlist() %>% 
  c(timestamp = as.character(Sys.time()),.)


dfCurrUser <- currentUser%>% 
  as.list() %>% 
  data.frame()
  
# set up first row and first data row to initialise

nanopoolGs <- nanopoolGs %>% 
  gs_ws_rename(to = "currentUser")

nanopoolGs <- nanopoolGs %>% 
  gs_ws_new(ws_title = "user")

nanopoolGs %>% 
  gs_edit_cells(ws = "currentUser", input = head(dfCurrUser, 1), trim = F)

nanopoolGs %>% 
  gs_edit_cells(ws = "user", input = head(dfCurrUser, 1), trim = F)


# add next row
nanopoolGs %>% 
  gs_add_row(ws = 1, input = currentUser)

# Nicehash set up current stats provider
gs_ls()
niceHashGs <- gs_new("niceHash", ws_title = "stats.provider")

testInput <- test$result$stats %>% 
  bind_rows() %>% 
  mutate(timeStamp = as.character(Sys.time()))

test$result$payments %>% 
  bind_rows()

niceHashGs %>% gs_edit_cells(input = testInput)
niceHashGs %>% gs_add_row(input = testInput)

testInput
