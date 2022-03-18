//
//  DetailTableViewController.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 16/03/2022.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var currencyImage: UIImageView!
    
    @IBOutlet weak var currencyName: UILabel!
    
    @IBOutlet weak var symbolLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var marketLabel: UILabel!
    
    @IBOutlet weak var circulatingSupplyLabel: UILabel!
    
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var totalSupplyLabel: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var maxSupplyLabel: UILabel!
    
    @IBOutlet weak var fullyDialutedMarketCapLabel: UILabel!
    
    /// Presenter
    private let detailTableviewPresenter:DetailTableViewPresenter = DetailTableViewPresenter.init(imageFetcher: DataFetcher())
   
    /// This object is using to hold the selected item , using this object we are going to show the other properties of the selected currency here.
    var currency:Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Set Delegate To the Presenter
        detailTableviewPresenter.attachView(self)
        
        self.navigationController?.navigationBar.tintColor = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
        
        /// Display the details of currency
        self.configureDetailViewWithItem(currency: self.currency!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    /// This method is using to show the all details of selsected currency.
    func configureDetailViewWithItem(currency:Currency){
        
        self.currencyName.text = currency.name
        self.detailTableviewPresenter.setImage(urlString: currency.image)
        self.symbolLabel.text = currency.symbol
        self.detailTableviewPresenter.setCurrencyPrice(currency.currentPrice)
        
        self.marketLabel.text =  String(format: "€ \( Utilities.df2so(currency.marketCap))")
        self.lowLabel.text = Utilities.df2so(currency.low24H) == "0" ? String(format: "€ \(currency.low24H.toString())"):  String(format: "€ %.2f", currency.low24H)

        self.highLabel.text = Utilities.df2so(currency.high24H) == "0" ? String(format: "€ \(currency.high24H.toString())"):  String(format: "€ %.2f", currency.high24H)

        if let tepDialution = currency.fullyDilutedValuation{
            self.fullyDialutedMarketCapLabel.text = String(format: "€ \( Utilities.df2so(tepDialution))")
        }
        self.maxSupplyLabel.text = currency.maxSupply != nil ? String(format: "%f", currency.maxSupply!) : ""
        self.totalSupplyLabel.text = currency.totalSupply != nil ? String(format: "%f", currency.totalSupply!) : ""
        self.circulatingSupplyLabel.text = String(format: "%f", currency.circulatingSupply)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
   /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        return cell
    }*/

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailTableViewController:DetailTableViewDelegate{
    func startLoading() {
        self.activityIndicatorView.startAnimating()
    }
    
    func finishLoading() {
        self.activityIndicatorView.stopAnimating()
    }
    
    func setImage(_ data: Data?) {
        if data != nil{
            self.currencyImage.image = UIImage.init(data: data!)
        }
    }
    
    func setCurrencyPrice(_ string: String) {
        
        self.priceLabel.text = string
        
    }
    
    
}
