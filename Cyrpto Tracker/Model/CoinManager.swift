//
//  CoinManager.swift
//  Cyrpto Tracker
//
//  Created by Amit Tandel on 4/5/23.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

let bitcoin = "BTC"
let dogecoin = "DOGE"
let ethcoin = "ETH"

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    
    let bitcoinURL = "https://rest.coinapi.io/v1/exchangerate/\(bitcoin)"
    
    let dogecoinURL = "https://rest.coinapi.io/v1/exchangerate/\(dogecoin)"
    
    let ethcoinURL = "https://rest.coinapi.io/v1/exchangerate/\(ethcoin)"
    
    let apiKey = "38968CA4-8122-4CAE-9A79-627C9440FC5A"
        
    let currencyArray = ["AUD", "USD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlStringBitcoin = "\(bitcoinURL)/\(currency)?apikey=\(apiKey)"
        print(urlStringBitcoin)
        
        let urlStringEthereum = "\(ethcoinURL)/\(currency)?apikey=\(apiKey)"
        print(urlStringEthereum)
        
        let urlStringDoge = "\(dogecoinURL)/\(currency)?apikey=\(apiKey)"
        print(urlStringDoge)
        
        if let url = URL(string: urlStringBitcoin) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

