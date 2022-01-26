//
//  CoinManager.swift
//  CoinRate
//
//  Created by David Chester on 1/17/22.
//

import Foundation


protocol CoinManagerDelegate {
    func didUpdateExchangeRate(price: String, currency: String)
    
    func didFailWithError(error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    // API Key from coinAPI.io, we call this with the url add on of ?apikey=
    let apiKey = "01641997-4F34-4DC3-9C50-507A22C2CF43"
    
    let currencyCountryArray = ["AUD","BRL","CAD","EUR","GBP","HKD","JPY","MXN","NZD","SGD","USD"]
    
    
    let coinKeyValues: KeyValuePairs =  ["BTC" : "Bitcoin",
                                         "ETH" : "Ethereum",
                                         "DOGE" : "Dogecoin",
                                         "USDT" : "Tether",
                                         "SOL" : "Solana",
                                         "ADA" : "Cardano",
                                         "LTC" : "Litecoin",
                                         "XRP" : "Ripple",
                                         "LUNA" : "Terra",
                                         "MATIC" : "Polygon",
                                         "DOT" : "Polkadot"]

    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(currency: String, coin: String){
        let urlString = "\(baseURL)\(coin)/\(currency)?apikey=\(apiKey)"
        
        print(urlString)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data {
                        if let coinPrice = self.parseJson(safeData) {
                            let priceString = String(format: "%.2f", coinPrice)
                                self.delegate?.didUpdateExchangeRate(price: priceString, currency: currency)

                        }
                    }
                }
                
                task.resume()
                
            }
        }
       
        
    }
    
    func parseJson(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
