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
        self.currencyName.text = currency.name
        self.activityController.startAnimating()
        URLSession.shared.dataTask( with: URL(string:currency.image)! as URL, completionHandler: {
              (data, response, error) -> Void in
              DispatchQueue.main.async {
                 if let data = data {
                     self.currencyImage.image = UIImage(data: data)
                     self.activityController.stopAnimating()
                 }
              }
        }).resume()
        self.currencySymbol.text = currency.symbol
        self.currencyPrice.text =  Utilities.df2so(currency.currentPrice) == "0" ? String(format: "€ \(currency.currentPrice.toString())"):  String(format: "€ %.2f", currency.currentPrice)
        self.percentageLabel.text = String(format: "%.2f%%", currency.priceChangePercentage24H)
        self.percentageLabel.textColor = (currency.priceChangePercentage24H < 0) ? .red : .green
        self.perImageConstraint.constant = (currency.priceChangePercentage24H < 0) ? 2.5 : -2.5
        let imageName = (currency.priceChangePercentage24H < 0) ? "DownArrow" : "UpArrow"
        self.percentageImage.image = UIImage.init(named:imageName)
    }
}

// MARK: - TableViewController

class CurrencyTableViewController: UITableViewController {
    
   
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
        let dataFetcher  = DataFetcher()
    
        self.loading.startAnimating()
        dataFetcher.getDataForAllCurencies { (coinArray) in
            guard let coinArray = coinArray else {
                return
            }
            
            DispatchQueue.main.async {
                self.currencySource = coinArray
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.loading.stopAnimating()
                print("Total Array count is \(self.currencySource.count)")
            }
            print(coinArray);
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.title = "CoinMarket"
        
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 77
        
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


