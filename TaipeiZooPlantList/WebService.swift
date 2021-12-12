//
//  WebService.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import Foundation

class WebService{
    class func request(urlStr: String,param: [String : String],complete: @escaping (NSDictionary?) -> Void){
        guard var component = URLComponents(string: urlStr) else{
            complete(nil)
            return
        }
        component.queryItems = param.map{ URLQueryItem(name: $0.key, value: $0.value)}
        
        var request = URLRequest(url: component.url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,error == nil else{
                complete(nil)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            complete(json)
        }
        task.resume()
    }
}
