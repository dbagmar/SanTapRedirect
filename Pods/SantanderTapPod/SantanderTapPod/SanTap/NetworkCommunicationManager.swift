
import Foundation
import SystemConfiguration

enum ErrorResult: Error {
    case network(statusCode:Int,responseMessage:String)
    case parser(statusCode:Int,responseMessage:String)
    case custom(statusCode:Int,responseMessage:String)
}

enum NetworkResult<T, E: Error> {
    case success(T)
    case failure(E)
}



    
func networkRequestWith(entity:String,action:String,queryParameters:[String:String]? = nil ,reqBody:Any?,httpHeaders:[String:String]? = nil,isTokenRequired:Bool,completionHandler:@escaping(Result<Data, ErrorResult>)-> ())
{
    
   
    guard var urlComponents: URLComponents = URLComponents(string: (entity)) else
    {
        printLog("url componets is nil");
        return;
    }
    
    if queryParameters != nil
    {
           urlComponents.setQueryItems(with: queryParameters!)
    }

   
    guard let url: URL =  urlComponents.url else
    {
        printLog("url is nil");
        return;
    }
    
    var urlrequest:URLRequest = URLRequest(url:url , cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 180)
    
    if httpHeaders != nil
    {
        for header in httpHeaders!{
            urlrequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    
    
    if(isTokenRequired)
    {
        
        let token = "eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE1ODE2Mzk3MjksImhhc2giOiI3ODQ4ZjdiYWUzMDllNjhlMGRjNTdjMzdiZTJhZTAwOCIsInVzZXJuYW1lIjoiMTIzNDU2Nzg5MDEyMzQ1Njc4OTAifQ.SU_Agu0CJRPeEDl_gYdDQjJ__8lT8zj9FuS5yvb5AwMILf5rKUP8zIY7I-dQnwk_6AnGXde2it5TlekGjdhNXw"
        
        if (token != " " )//let token = tokenStr//(UserDefaults.standard.value(forKey: TOKEN))
        {
            let authorization:String = "Bearer \(token)"
            urlrequest.addValue(authorization, forHTTPHeaderField: "Authorization")
        }
        
        
    }
    
    urlrequest.httpMethod = action
    
    
    if(POST_ACTION.caseInsensitiveCompare(action) == .orderedSame)
    {
        guard  reqBody != nil else
        {
            printLog("url is nil");
            return;
        }
        
        let jsonData:Data?
        
        if(reqBody is Data)
        {
               urlrequest.httpBody = reqBody as? Data
                jsonData = reqBody as? Data
                urlrequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
           
             // urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
        }else if (reqBody is String){
            
            let bodyString:String = reqBody as? String ?? " "
            urlrequest.httpBody = bodyString.data(using: .ascii)
            
            if !(entity.contains("token")) {
                urlrequest.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            }
            
            
        }else{
            
            urlrequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //  urlrequest.addValue("application/json", forHTTPHeaderField: "Accept")
             jsonData = try? JSONSerialization.data(withJSONObject: reqBody!)
            let requestData =  String(data: jsonData ?? Data(),
                                       encoding: String.Encoding.ascii)
            printLog("Request : \(urlrequest.description) \(String(describing: requestData)) ")
             
             
        }
        
        
    }else{
         printLog("Request : \(urlrequest.description)")
        
    }
    
     var urlSession = URLSession.shared
     let keys = "keys/"+urlKey
     if !entity.contains(keys){
         urlSession = URLSession(
         configuration: URLSessionConfiguration.ephemeral,
         delegate: NSURLSessionPinningDelegate(),
         delegateQueue: nil)//URLSession.shared/*
     }
   
     
    
    let network = try? Reachability()
    if (network?.isConnectedToNetwork ?? false)
    {
        urlSession.dataTask(with: urlrequest) { (data, urlResponse, error) in
            
            DispatchQueue.main.async {
                
                guard error == nil else
                {
                    printLog("Error: ", error!)
                    completionHandler(.failure(.network(statusCode: -1, responseMessage: "An error occured during request :" + (error?.localizedDescription ?? ""))))
                  
                    return
                }
                
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else{
                    
                     completionHandler(.failure(.network(statusCode: -2, responseMessage: "An error occured during request : Http Response Failed")))
                    
                    
                    return
                }
                
                let statusCode = httpResponse.statusCode
                
                
                if (statusCode != 200) {
                    
                    printLog ("dataTaskWithRequest HTTP status code:", statusCode)
                    if entity.contains("security/sing_in_keyboard" ){
                        
                   
                }
                    
                  completionHandler(.failure(.network(statusCode: statusCode, responseMessage: "An error occured during request :" + SOME_ERROR_OCCUERD)))
                    return;
                }
                
                guard let data = data else
                {
                    completionHandler(.failure(.network(statusCode: statusCode, responseMessage: "An error occured during request data :" + SOME_ERROR_OCCUERD)))
                    
                    return
                }
                
                let theJSONText = String(data: data,
                                         encoding: String.Encoding.ascii)
                
                printLog("Response Data:  \(entity) \(theJSONText ?? "")")
                
              //  let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if #available(iOS 13.0, *)  {
                    let responseHeader = httpResponse.value(forHTTPHeaderField: "X-Auth-Token")
                      printLog("\(responseHeader ?? " ")")
                     if responseHeader != " "{
                         _ = authToken.init(token: responseHeader ?? " ")
                         UserDefaults.standard.set(responseHeader ?? " ", forKey: AuthConstant.authToken)
                     }
                } else {
                    
                    if let response = httpResponse as? HTTPURLResponse {
                        let headers = response.allHeaderFields as? [String: String]
                        
                        let responseHeader = headers?["X-Auth-Token"] ?? " "
                        printLog("\(responseHeader )")
                        if responseHeader != " "{
                            _ = authToken.init(token: responseHeader )
                            UserDefaults.standard.set(responseHeader, forKey: AuthConstant.authToken)
                        }
                        
                    }else {
                    
                    }
                    // Fallback on earlier versions
                }
            
              
               
                 completionHandler(.success(data))
                
            }
            
        }.resume()
    }else
    {
        //AppUtility.displayToast(message: NO_NETWORK_CONNECTION)
        
        completionHandler(.failure(.network(statusCode: -1, responseMessage: "An error occured during request data :" + NO_NETWORK_CONNECTION)))
        
    }
    
   

    
    
}


