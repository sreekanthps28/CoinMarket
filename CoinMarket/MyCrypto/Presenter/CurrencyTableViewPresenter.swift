//
//  CurrencyTableViewPresenter.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 18/03/2022.
//

import Foundation

// MARK: - CurrencyTableViewCell Presenter Protocol
protocol CurrencyTableViewCellDelegate: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setImage(_ data:Data?)
    func setCurrencyPrice(_ string:String)
}
// MARK: - CurrencyTableViewCell Presenter class
class CurrencyCellPresenter{
    fileprivate let imageService:DataFetcher
    weak fileprivate var currencyTableViewCellDelegate : CurrencyTableViewCellDelegate?
    
    /// Initialising with DataFetcher
    init(imageFetcher:DataFetcher){
        self.imageService = imageFetcher
    }
    
    /// Setting Delegate
    func attachView(_ view:CurrencyTableViewCellDelegate){
        currencyTableViewCellDelegate = view
    }
    
    /// Remove delegate
    func detachView() {
        currencyTableViewCellDelegate = nil
    }
    
    /// Fetch Image with the help of DataFetcher Class
    func setImage(urlString:String){
        self.currencyTableViewCellDelegate?.startLoading()
        self.imageService.getImage(urlString: urlString) { data in
            self.currencyTableViewCellDelegate?.setImage(data)
            self.currencyTableViewCellDelegate?.finishLoading()
        }
        
    }
    
    func setCurrencyPrice(_ value:Double?){
        
        if let price = value{
            self.currencyTableViewCellDelegate?.setCurrencyPrice(Utilities.df2so(price) == "0" ? String(format: "€ \(price.toString())"):  String(format: "€ %.2f", price))
        }else{
            
            self.currencyTableViewCellDelegate?.setCurrencyPrice("")
            
        }
    }
}

// MARK: - CurrencyTableView Presenter Protocol

protocol CurrencyTableViewDelegate: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setCurrencies(_ currencies: [Currency])
}

// MARK: - CurrencyTableView Presenter Class

class CurrencyPresenter {
    fileprivate let currencyService:DataFetcher
    weak fileprivate var currencyTableViewDelegate : CurrencyTableViewDelegate?
    
    /// Initialising with DataFetcher
    init(currencyFetcher:DataFetcher){
        self.currencyService = currencyFetcher
    }
    /// Setting Delegate
    func attachView(_ view:CurrencyTableViewDelegate){
        currencyTableViewDelegate = view
    }
    
    /// Remove delegate
    func detachView() {
        currencyTableViewDelegate = nil
    }
    
    /// Fetch Currencies with the help of DataFetcher Class
    
    func getCurrencies(){
    
        self.currencyTableViewDelegate?.startLoading()
        
        currencyService.getDataForAllCurencies { coins in
            
            self.currencyTableViewDelegate?.setCurrencies(coins ?? [])
            
            self.currencyTableViewDelegate?.finishLoading()
            
        }
    }
}
