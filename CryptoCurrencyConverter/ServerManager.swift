//
//  ServerManager.swift
//  CryptoCurrencyConverter
//
//  Created by Torris on 8/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit
import Foundation

final class ServerManager {
    
    // Can't init is singleton
    private init() { }
    
    //Shared Instance
    
    static let shared = ServerManager()
    
    //Instance`s methods
    
    func getItems(completion: @escaping ([Currency]?) -> ()) {
        
        
        // create URL
        
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/") else {
            print("Error: Cannot compose  the URL")
            completion(nil)
            return
        }
        
        // load data from web
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Error while fetching data from Web: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let dataConfirmed = data else {
                print("Error: nil data receive from Web")
                
                if let responseConfirmed = response {
                    
                    debugPrint("Here`s the response: \(responseConfirmed)")
                }
                completion(nil)
                return
            }
            
            // parse data
            
            guard let json = try? JSONSerialization.jsonObject(with: dataConfirmed, options: .mutableContainers) else {
                print("Error parsing JSON")
                completion(nil)
                return
            }
            
            //print(json)
            
            guard let jsonConfirmed = json as? [[String:Any]] else {
                print("Error: malformed data in parsed object")
                completion(nil)
                return
            }
            
            var itemsArray = [Currency]()
            
            for itemDict in jsonConfirmed {
                
                if let item = Currency(paramsDict: itemDict) {
                    
                    itemsArray.append(item)
                }
            }
            
            DispatchQueue.main.async(execute: {
                completion(itemsArray)
            })
        })
        
        task.resume()
        
    }
    
}
