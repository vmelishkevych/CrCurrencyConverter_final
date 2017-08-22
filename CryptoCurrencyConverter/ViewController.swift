//
//  ViewController.swift
//  CryptoCurrencyConverter
//
//  Created by Torris on 8/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    

    
    var currentCurrency: Currency?
    
    let nf = NumberFormatter()
    var directOrder = true

  
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var sourseLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var firstOutputLabel: UILabel!
    @IBOutlet weak var secondOutputLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "CryptoCurrency Converter"
        
        
        // set formatter`s params
        
        nf.maximumFractionDigits = 6
        nf.minimumFractionDigits = 2

        
       // set subviews
        
        toggleButton.setTitle("\u{21C6}", for: .normal)

        toggleButton.layer.cornerRadius = 5.0
        
        defineNamesInputLabels()

        defineOutputValues()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Help methods
    

    func defineFullCurrencyName() -> String {
        
        if let currentCurrency = currentCurrency {
            
            let symbol = currentCurrency.symbol ?? ""
            return currentCurrency.name + " (" + symbol + ")"
        
        } else {
            
            return "Currency not found"
        }
    }
    
    
    
    func defineNamesInputLabels() {
        
        let fullNameOfCurrency = defineFullCurrencyName()
        
        sourseLabel.text = (directOrder) ? fullNameOfCurrency : "USD"
        destinationLabel.text = (directOrder)  ? "USD" : fullNameOfCurrency
        
    }
    
    
    
    func defineOutputValues(){
        
        if let currentCurrency = currentCurrency {
            
            let firstOutputValue: Double
            
            if amountTextField.text != nil {
                
                firstOutputValue = Double(amountTextField.text!) ?? 1.0
                
            } else {
                
                firstOutputValue = 1.0
            }
            
            let nameOfCurrency = currentCurrency.symbol ?? currentCurrency.name
            
            firstOutputLabel.text = (directOrder) ? formatValueToString(firstOutputValue) + " " + nameOfCurrency :
                formatValueToString(firstOutputValue) + " USD"
            
            if let ratio = Double(currentCurrency.price), ratio != 0 {
                
                let secontOutputValue = (directOrder) ? firstOutputValue * ratio : firstOutputValue / ratio
                
                secondOutputLabel.text = (directOrder) ? formatValueToString(secontOutputValue) + " USD" :
                    formatValueToString(secontOutputValue) + " " + nameOfCurrency
                
            } else {
                
                secondOutputLabel.text = "price not found"
                
            }
        }
    }


    
    func formatValueToString(_ number: Double) -> String {
        
        let fNumber = NSNumber.init(floatLiteral: number)
        
        

        nf.numberStyle = (number > 1000000000.0) ? .scientific : .decimal
        
        
        return nf.string(from: fNumber)!
        

    }
    
 
    // MARK: Actions
    
    
    @IBAction func toggleButtonAction() {
        
        directOrder = !directOrder
        
        defineNamesInputLabels()
        defineOutputValues()

    }
    
    
    @IBAction func editingChangedTextFieldAction(_ sender: UITextField) {
        
        defineOutputValues()

    }
    
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let unionSet = NSMutableCharacterSet.decimalDigit()
        unionSet.addCharacters(in: ".")
        let finalSet = unionSet.inverted
        let components = string.components(separatedBy: finalSet)
        
        if (components.count > 1) {
            return false
        }
        
        
        
        let flagStr = string.contains(".")
        let flagPref = string.hasPrefix(".")

        if let text = textField.text, !text.isEmpty {
            
            let flagText = text.contains(".")
            
            switch (flagText, flagStr, flagPref) {
            case (false, false, _), (false, true, _), (true, false, _):
                return true
            case (true, true, _):
                return false
            }
            
        } else {
            
            switch (flagStr, flagPref) {
            case (false, _), (true, false):
                return true
            case (true, true):
                return false
            }
        }
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

