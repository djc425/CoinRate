//
//  ViewController.swift
//  CoinRate
//
//  Created by David Chester on 1/16/22.
//

import UIKit

class ViewController: UIViewController {
    
    // top field where chosen coin and current exchance price is shown
    var currentPriceLabel: UILabel!
    var currentCoinLabel: UILabel!
    var currencySymbolView = UIImageView()
    var currencySymbol: UIImage!
    var currentPriceTitle: UILabel!
    var topField = UIView()
    
    // currency picker
    var selectedCurrencyLabel: UILabel!
    var currencySelectorPicker: UIPickerView!
    var currencyField = UIView()
    
    // coin pikcer
    var selectedCoinLabel: UILabel!
    var coinSelectorPicker: UIPickerView!
    var coinField = UIView()
    
    var coinManager = CoinManager()
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinSelectorPicker.delegate = self
        coinSelectorPicker.dataSource = self
        coinSelectorPicker.tag = 1
        
        currencySelectorPicker.delegate = self
        currencySelectorPicker.dataSource = self
        currencySelectorPicker.tag = 2
        
        coinManager.delegate = self
        
    }
    // stroke for currentPriceTitle
    private func stroke(strokeWidth: Float, strokeColor: UIColor) -> [NSAttributedString.Key: Any]{
        return [
            NSAttributedString.Key.strokeColor : strokeColor,
          //  NSAttributedString.Key.foregroundColor : insideColor,
            NSAttributedString.Key.strokeWidth : -strokeWidth,
           // NSAttributedString.Key.font : font
            ]
    }



}

extension ViewController: CoinManagerDelegate {
    func didUpdateExchangeRate(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currentPriceLabel.text = price
            self.currentCoinLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
     print("The didFailWithErrorMessage was triggered: \(error)")
    }
    
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    // reminder: coinPicker is tag 1, currencyPicker is tag 2
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return coinManager.coinKeyValues.count
        }
        else if pickerView.tag == 2{
            return coinManager.currencyCountryArray.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            
            return coinManager.coinKeyValues[row].key
        }
        else if pickerView.tag == 2{
            return coinManager.currencyCountryArray[row]
        } else {
            return "Blank"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedCoinLabel.text = coinManager.coinKeyValues[row].value
        }
        if pickerView.tag == 2 {
            selectedCurrencyLabel.text = coinManager.currencyCountryArray[row]
        }
        
        coinManager.getCoinPrice(currency: selectedCurrencyLabel.text!, coin: coinManager.coinKeyValues[row].key)
    }
    
    
    
}

// MARK: Load View extension + Constraints
extension ViewController {
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red: 104/255, green: 103/255, blue: 172/255, alpha: 1.0)
        
        //Top field properties
        currentPriceLabel = UILabel()
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.text = ""
        currentPriceLabel.font = UIFont(name: "Futura", size: 24.0)
        currentPriceLabel.textAlignment = .center
        currentPriceLabel.backgroundColor = UIColor(red: 206/255, green: 123/255, blue: 176/255, alpha: 0.4)
        currentPriceLabel.layer.masksToBounds = true
        currentPriceLabel.layer.cornerRadius = 10
        topField.addSubview(currentPriceLabel)
        
        currentCoinLabel = UILabel()
        currentCoinLabel.translatesAutoresizingMaskIntoConstraints = false
        currentCoinLabel.text = "BTC"
        currentCoinLabel.font = UIFont(name: "Futura", size: 24.0)
        topField.addSubview(currentCoinLabel)
        
        currentPriceTitle = UILabel()
        currentPriceTitle.translatesAutoresizingMaskIntoConstraints = false
        currentPriceTitle.text = "current price per coin"
        currentPriceTitle.font = UIFont(name: "Futura", size: 17)
        currentPriceTitle.textColor = .white
        currentPriceTitle.textAlignment = .center
        currentPriceTitle.attributedText = NSAttributedString(string: currentPriceTitle.text!, attributes: stroke(strokeWidth: 0.4, strokeColor: UIColor.gray))
        topField.addSubview(currentPriceTitle)
        
        topField.translatesAutoresizingMaskIntoConstraints = false
        topField.backgroundColor = UIColor(red: 255/255, green: 188/255, blue: 209/255, alpha: 1/0)
        view.addSubview(topField)
        
        // currency field properties
        selectedCurrencyLabel = UILabel()
        selectedCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedCurrencyLabel.text = "USD"
        selectedCurrencyLabel.font = UIFont(name: "Futura", size: 24)
        selectedCurrencyLabel.textAlignment = .center
        currencyField.addSubview(selectedCurrencyLabel)
    
        currencySelectorPicker = UIPickerView()
        currencySelectorPicker.translatesAutoresizingMaskIntoConstraints = false
        currencyField.addSubview(currencySelectorPicker)
        
        currencyField.translatesAutoresizingMaskIntoConstraints = false
        //currencyField.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        view.addSubview(currencyField)
        
        // coin field properties
        selectedCoinLabel = UILabel()
        selectedCoinLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedCoinLabel.text = "BTC"
        selectedCoinLabel.font = UIFont(name: "Futura", size: 24)
        selectedCoinLabel.textAlignment = .center
        coinField.addSubview(selectedCoinLabel)
        
        coinSelectorPicker = UIPickerView()
        coinSelectorPicker.translatesAutoresizingMaskIntoConstraints = false
        coinField.addSubview(coinSelectorPicker)
        
        coinField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coinField)
        
        // MARK: Constraints
        NSLayoutConstraint.activate([
            
            // top field constraints
            currentPriceLabel.centerXAnchor.constraint(equalTo: topField.centerXAnchor, constant: 20),
            currentPriceLabel.centerYAnchor.constraint(equalTo: topField.centerYAnchor, constant: 20),
            currentPriceLabel.widthAnchor.constraint(equalTo: topField.widthAnchor, multiplier: 0.5),
            currentPriceLabel.heightAnchor.constraint(equalTo: topField.heightAnchor, multiplier: 0.2),
            
            currentCoinLabel.centerYAnchor.constraint(equalTo: currentPriceLabel.centerYAnchor),
            currentCoinLabel.trailingAnchor.constraint(equalTo: currentPriceLabel.leadingAnchor, constant: -10),
            
            currentPriceTitle.centerXAnchor.constraint(equalTo: currentPriceLabel.centerXAnchor),
            currentPriceTitle.bottomAnchor.constraint(equalTo: currentPriceLabel.bottomAnchor, constant: 20),
            
            
        
            topField.widthAnchor.constraint(equalTo: view.widthAnchor),
            topField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            topField.topAnchor.constraint(equalTo: view.topAnchor),
            
            // currency field constraints
            currencySelectorPicker.centerYAnchor.constraint(equalTo: currencyField.centerYAnchor),
            currencySelectorPicker.widthAnchor.constraint(equalTo: currencyField.widthAnchor, multiplier: 0.5),
            currencySelectorPicker.trailingAnchor.constraint(equalTo: currencyField.trailingAnchor, constant: 20),
            currencySelectorPicker.heightAnchor.constraint(equalTo: currencyField.heightAnchor, multiplier: 0.9),
            
            selectedCurrencyLabel.centerYAnchor.constraint(equalTo: currencySelectorPicker.centerYAnchor),
            selectedCurrencyLabel.leadingAnchor.constraint(equalTo: currencyField.leadingAnchor, constant: 20),
          
            currencyField.topAnchor.constraint(equalTo: topField.bottomAnchor, constant: 50),
            currencyField.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.2),
            currencyField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.7),
            currencyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // coin field restraints
            
            coinSelectorPicker.centerYAnchor.constraint(equalTo: coinField.centerYAnchor),
            coinSelectorPicker.heightAnchor.constraint(equalTo: currencySelectorPicker.heightAnchor),
            coinSelectorPicker.trailingAnchor.constraint(equalTo: coinField.trailingAnchor, constant: 20),
            coinSelectorPicker.widthAnchor.constraint(equalTo: currencySelectorPicker.widthAnchor),
            
            selectedCoinLabel.centerYAnchor.constraint(equalTo: coinField.centerYAnchor),
            selectedCoinLabel.leadingAnchor.constraint(equalTo: coinField.leadingAnchor, constant: 20),
            
            coinField.topAnchor.constraint(equalTo: currencyField.bottomAnchor, constant: 50),
            coinField.heightAnchor.constraint(equalTo: currencyField.heightAnchor),
            coinField.widthAnchor.constraint(equalTo: currencyField.widthAnchor),
            coinField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        
        ])
        
        
    }
}

