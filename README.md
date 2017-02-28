# mrs
How data scientists can share their model with SW developers in a more automated fashion, for operationalization.

How is it done?
With 1 line of code.

Publish Service – 1 line command:
##################################################################
#   Step 3: Publish as a web service                             #
##################################################################
#updateService is helpful in iterative operationalization
api <- publishService(
  "PredictedY",
  code = f_predictedY,
  model = theYPredictorModel,
  inputs = list(newdata = "numeric"),
  outputs = list(answer = "data.frame"),
  v = "v1.3.7")


Logins can be done a simple way that a team mate can sign into a pop up window with their own credentials :
remoteLogin(
"http://localhost:12800/",
  session = FALSE)



Resources:
API documentation:
MRS: https://microsoft.github.io/deployr-api-docs/9.0.1/#statusresponse
Swagger: http://editor.swagger.io/#/

