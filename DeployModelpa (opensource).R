#Deploy R file in text:
  #
  # Load R model from hard drive and use it to predict a Y value.
  #
  
setwd("C:/Temp/(Dir)")

load(file="Model.R")

xValue = 8
predictedY = predict(theYPredictorModel, newdata=data.frame(x = xValue))
predictedY

##################################################################
#   Step 1: Create a scoring function                            #
##################################################################

# Wrap up the prediction to a function for easy consumption
f_predictedY <- function(predictData) {
  predict(theYPredictorModel, newdata = data.frame(x = predictData))
}

f_predictedY(8)

##################################################################
#   Step 2: Loginto R Server that hosts the web services         #
##################################################################

#remoteLogin(
#  "http://localhost:12800/",
#  session = FALSE)

#For completeness, I am logging out first
remoteLogout()

#LOGIN
#Remain local without creating a remote R session (3)
#In this state, you can authenticate with remoteLogin() and its argument session = FALSE so that no remote R session is started. Without a remote R session, you'll only have the local R environment and command line.

# EXAMPLE OF LOGIN WITHOUT REMOTE R SESSION
remoteLogin(
  "http://localhost:12800",
  session = FALSE
)

#On premises authentication
#If you are authenticating using Active Directory server on your network or the default administrator account for an on-premises instance of R Server, use the remoteLogin function. This function calls /user/login API, which requires a username and password. For the entire set of arguments for this function, check the R help topic in the package help. For example:

#Below, I login with my IP address instead of local host if I want. I can share this with my colleagues as well if I want them to login to my R server.
remoteLogin("http://10.84.48.17:12800",
session = TRUE,
diff=TRUE,
commandline = TRUE,
prompt="remote>>>>",
username="admin",
password="xxxxxxxx")




#Pause your remote connection to get back to your client console
pause()

##################################################################
#   Step 3: Publish as a web service                             #
##################################################################

api <- publishService(
  "PredictedY",
  code = f_predictedY,
  model = theYPredictorModel,
  inputs = list(newdata = "numeric"),
  outputs = list(answer = "data.frame"),
  v = "v1.3.7")

# check how to consume the service
api$capabilities()


# verify it right away in R!
result <- api$f_predictedY(8)
print(result$output("answer"))

##################################################################
#   Step 4: Generate a swagger doc for integration with apps     #
##################################################################
swagger <- api$swagger()
cat(swagger, file = "swagger.json", append = FALSE)

#new pa - give me my endpoint link to put into postman
cap <-api$capabilities()
cap
cap$swagger
#Format:"http://10.0.0.111:12800/api/PredictedY/v1.3.1/swagger.json"


##################################################################
#   Step 5: cURL within R Studio
##################################################################


library(RJSONIO)
library(RCurl)
library(httr)
library(jsonlite)

postResult <- POST("http://10.84.48.17:12800/login",
  accept_json(),
  add_headers("Content-Type" = "application/json"),
  body = toJSON(list(
    "username" = "admin",
    "password" = "xxxxxx"
  ))
)

##there is one problem though .. 
##the postResult$content is in Binary format I guess .. 
##we will need to encode/convert it as JSON 
#This is an Example only for those who want to get the result in R Server itself
# Those who use curl or postman can still use the JSON file or the Rest API
s <- paste(postResult$content, collapse="") 
h <- sapply(seq(1, nchar(s), by=2), function(x) substr(s, x, x+1))
rawToChar(as.raw(strtoi(h, 16L)))



