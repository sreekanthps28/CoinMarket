//
//  CurrencyTableViewController.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 15/03/2022.
//

import UIKit
import NVActivityIndicatorView

// MARK: - TableviewCell

class CurrencyTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    /// Presenter
    private let currencyTableViewCellPresenter:CurrencyCellPresenter = CurrencyCellPresenter.init(imageFetcher: DataFetcher())
    
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageImage: UIImageView!
    @IBOutlet weak var currencyPrice: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var perImageConstraint: NSLayoutConstraint!
   
    /// Configue Cell Object with the corresponding item.
    func configureCellwithItem(currency: Currency){
        
        /// Set Delegate To the Presenter
        currencyTableViewCellPresenter.attachView(self)
        
        self.currencyName.text = currency.name
        self.currencyTableViewCellPresenter.setImage(urlString: currency.image)
        self.currencySymbol.text = currency.symbol
        self.currencyTableViewCellPresenter.setCurrencyPrice(currency.currentPrice)
        self.percentageLabel.text = String(format: "%.2f%%", currency.priceChangePercentage24H)
        self.percentageLabel.textColor = (currency.priceChangePercentage24H < 0) ? .red : .green
        self.perImageConstraint.constant = (currency.priceChangePercentage24H < 0) ? 2.5 : -2.5
        self.percentageImage.image = (currency.priceChangePercentage24H < 0) ? UIImage.init(named:"DownArrow") : UIImage.init(named:"UpArrow")
    }
}

// MARK: - CurrencyTableViewCellDelegate Methods

extension CurrencyTableViewCell:CurrencyTableViewCellDelegate {
    
    func setCurrencyPrice(_ string: String) {
        self.currencyPrice.text = string
    }
    
    func startLoading() {
        self.activityController.startAnimating()
    }
    
    func finishLoading() {
        self.activityController.stopAnimating()
    }
    
    func setImage(_ data: Data?) {
        if data != nil{
            self.currencyImage.image = UIImage.init(data: data!)
        }
    }
    
    
}

// MARK: - TableViewController

class CurrencyTableViewController: UITableViewController {
    
    /// Presenter
    private let currencyPrersenter:CurrencyPresenter = CurrencyPresenter.init(currencyFetcher: DataFetcher())
    
   
    /// Data source - Holding all currencies
    var currencySource:[Currency] = [Currency]()
    
    /// Configuring the activity indicator view thar is Using to Show the progress of loading currency image
    private let loading = NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .gray, padding: 0)
    
    private func configureLoading() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor)
        ])
    }
    
    /// Call the api to fetch the currency details
    
    @objc func loadCurrencyDetails(){
        ///Get all currency details  from API
        currencyPrersenter.getCurrencies()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = "CoinMarket"
        
        /// Setting Delegate
        currencyPrersenter.attachView(self)
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 77
        tableView.accessibilityIdentifier = "table--currencyTable"
        
       /// Configure the activity indicator  view
        configureLoading()
        
        /// Pull to refresh the datas
        self.refreshControl?.addTarget(self, action: #selector(loadCurrencyDetails), for: UIControl.Event.valueChanged)
        
        ///Fetch all the currencies
        loadCurrencyDetails()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.currencySource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableviewCell") as? CurrencyTableViewCell{
            cell.configureCellwithItem(currency: self.currencySource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetailsofCurrency(currency: self.currencySource[indexPath.row])
    }
    
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

   
    // MARK: - Navigation
     
     /// Detail View presentation - selected currency passed to the next view controller to display more properties of that item
     func showDetailsofCurrency(currency:Currency) {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         if let detailController = storyboard.instantiateViewController(withIdentifier:"DetailTableViewController") as? DetailTableViewController{
             detailController.currency = currency
             self.navigationController?.pushViewController(detailController, animated: true)
         }
     }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CurrencyTableViewDelegate Methods

extension CurrencyTableViewController: CurrencyTableViewDelegate {
  
    func startLoading() {
        self.loading.startAnimating()
    }

    func finishLoading() {
        self.loading.stopAnimating()
    }

    func setCurrencies(_ currencies: [Currency]) {
        DispatchQueue.main.async {
            self.currencySource = currencies
            self.tableView?.isHidden = false
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            print("Total Array count is \(self.currencySource.count)")
        }
    }

}


