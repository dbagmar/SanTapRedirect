

import Foundation

//let MAIN_URL = "https://bypass-app-paas-heroku.herokuapp.com/v2/" // url change on 22 may 2020

let urlKey = UserDefaults.standard.value(forKey: "URL") as? String ?? "PRE"

let MAIN_URL = UserDefaults.standard.value(forKey: urlKey) as? String ?? " "

//let MAIN_URL = "https://tap-pub-web-mxswap-pre.appls.cto1.paas.gsnetcloud.corp/v2/"


//"https://tap-mock-login-service.herokuapp.com/" -- local
//https://devs-dev.herokuapp.com/v2/  --Dev
//https://tap-pub-web-mxswap-pre.appls.cto1.paas.gsnetcloud.corp/v2/ -- Pre

let Local_URL = "https://tap-mock-login-service.herokuapp.com/"

let POST_ACTION = "POST"
let GET_ACTION = "GET"

let SUCCESS:String = "Success"
let FAILUER:String = "Failuer"
let SOME_ERROR_OCCUERD = "Some Error Occured"
let kMESSAGE = "message"

let DATA = "data"

let NO_NETWORK_CONNECTION = "Please check internet connection"

let AUTH:String = "auth"
let TOKEN:String = "token"
let UAT:String = "UAT"
let Dev:String = "DEV"
let Dev2:String = "DEV2"
let Pre:String = "PRE"
let Prod:String = "PRO"
let SSLPinKey:String = "SSLKey"
let UATKey:String = "UATKey"
let DevKey:String = "DevKey"
let PreKey:String = "PreKey"
let ProdKey:String = "ProdKey"
