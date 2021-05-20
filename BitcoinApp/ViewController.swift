//
//  ViewController.swift
//  BitcoinApp
//
//  Created by user191307 on 5/19/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //MARK: - Outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - Variables and Constants
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    let apiKey = "NmY4ZWJlYzI2MmVhNGEyMGE3MDNiODU0YjNlYTJjNTA"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(url: baseURL)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return curruncies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return curruncies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           
        var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        
        fetchData(url: url)
           
    }
    
    func fetchData(url: String) {
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
            
                self.parseJSON(json: data)
            }
            
            else {
                print("error")
                
            }
            
        }
        
        task.resume()
    }
    
    
    func parseJSON(json: Data) {
        
        do {
        
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.maximumFractionDigits = 2
                    formatter.decimalSeparator = ","
                    formatter.groupingSeparator = "."
                    
                    let fixedValue = formatter.string(from: askValue)
                    let askvalueString = fixedValue
                    DispatchQueue.main.async {

                        self.priceLabel.text = askvalueString
                    }
                    print("success")
            
                } else {
                    
                    print("error")
                }
            }
                    
        } catch {

            print("error parsing json: \(error)")
        }
        
    }


}

