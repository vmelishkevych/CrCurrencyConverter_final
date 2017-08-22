//
//  TableViewController.swift
//  CryptoCurrencyConverter
//
//  Created by Torris on 8/20/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController {

    
    var currenciesArray = [Currency]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.clearsSelectionOnViewWillAppear = true

        getCurrenciesFromServer()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Server Manager Methods
    
    // get data from Web
    
    func getCurrenciesFromServer() {
        
        self.currenciesArray.removeAll()
        tableView.reloadData()
        
        ServerManager.shared.getItems(completion: {items in
            
            
            if let currencies = items {
                
                self.currenciesArray.append(contentsOf: currencies)
                self.tableView.reloadData()
                
            } else {
                
                self.showAllertController(withTitle: nil, andMessage: "Data not found")
            }
            
        })
    }

    // MARK: Actions
    
    // refresh data from Web
    
    @IBAction func refreshBarButtonAction(_ sender: UIBarButtonItem) {
        
        getCurrenciesFromServer()

    }
    
    // MARK: Help methods
    
    // present alert on view
    
    func showAllertController(withTitle title: String?, andMessage message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        
        let actionTryAgain = UIAlertAction(title: "Try again", style: .destructive) { (UIAlertAction) in
            
            self.getCurrenciesFromServer()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionTryAgain)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    
    
    }
    

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell")
        
        let currency = currenciesArray[indexPath.row]
        cell?.textLabel?.text = currency.name
        cell?.detailTextLabel?.text = "$" + currency.price
        return cell!
    }
    

    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        // goto converter

        if let converterController = self.storyboard?.instantiateViewController(withIdentifier: "ConverterController") as? ViewController, indexPath.row < currenciesArray.count {
            
            self.navigationController?.pushViewController(converterController, animated: true)
            converterController.currentCurrency = currenciesArray[indexPath.row]
            
        }
    }
}
