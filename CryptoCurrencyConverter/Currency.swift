//
//  Currency.swift
//  CryptoCurrencyConverter
//
//  Created by Torris on 8/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit

class Currency {

    let name: String
    let price: String
    let symbol: String?
    
    init?(paramsDict: [String:Any]) {
        
        if let name = paramsDict["name"] as? String, let price = paramsDict["price_usd"] as? String  {

                self.name = name
                self.price = price

        } else {
            return nil
        }
        
        self.symbol = paramsDict["symbol"] as? String
    }
    
}
