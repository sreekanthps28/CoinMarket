//
//  DetailTableViewPresenter.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 18/03/2022.
//

import Foundation

// MARK: - DetailTableView Presenter Protocol
protocol DetailTableViewDelegate: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setImage(_ data:Data?)
    func setCurrencyPrice(_ string:String)
}
// MARK: - DetailTableView Presenter class
class DetailTableViewPresenter{
    fileprivate let imageService:DataFetcher
    weak fileprivate var detailTableViewDelegate : DetailTableViewDelegate?
    
    /// Initialising with DataFetcher
    init(imageFetcher:DataFetcher){
        self.imageService = imageFetcher
    }
    
    /// Setting Delegate
    func attachView(_ view:DetailTableViewDelegate){
        detailTableViewDelegate = view
    }
    
    /// Remove delegate
    func detachView() {
        detailTableViewDelegate = nil
    }
    
    /// Fetch Image with the help of DataFetcher Class
    func setImage(urlString:String){
        self.detailTableViewDelegate?.startLoading()
        self.imageService.getImage(urlString: urlString) { data in
            self.detailTableViewDelegate?.setImage(data)
            self.detailTableViewDelegate?.finishLoading()
        }
        
    }
    /// set current Price of Coin
    func setCurrencyPrice(_ value:Double?){
        
        if let price = value{
            self.detailTableViewDelegate?.setCurrencyPrice(Utilities.df2so(price) == "0" ? String(format: "€ \(price.toString())"):  String(format: "€ %.2f", price))
        }else{
            
            self.detailTableViewDelegate?.setCurrencyPrice("")
            
        }
    }
}
