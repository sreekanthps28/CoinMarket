//
//  DataFetcher.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 15/03/2022.
//
import Foundation
import UIKit

class DataFetcher {

    /// Use this method to fetch all the currencies from the api.
    func getDataForAllCurencies(completion: @escaping(_ coins: [Currency]?) -> Void) {
        
        let coinLimit = 100
        
        let strUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap _desc&per_page=\(coinLimit)&page=1&sparkline=false"
       
        if let encoded = strUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let myURL = URL(string: encoded) {
            
            URLCache.shared.removeAllCachedResponses()
            
            let task = URLSession.shared.dataTask(with: myURL) { (data, response, error) -> Void in
             
                guard let data = data else {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                let decoder = JSONDecoder()
                let items = try? decoder.decode([Currency].self, from: data)
                DispatchQueue.main.async { completion(items) }
            }
            task.resume()
        }
    }
    /// Use this method to fetch image from url string
    func getImage(urlString:String, completion: @escaping (Data?) -> ()) {
        
        URLSession.shared.dataTask( with: URL(string:urlString)! as URL, completionHandler: {
              (data, response, error) -> Void in
              DispatchQueue.main.async {
                  
                  guard let data = data else {
                      DispatchQueue.main.async { completion(nil) }
                      return
                  }
                  DispatchQueue.main.async { completion(data) }
              }
        }).resume()
    }
}
