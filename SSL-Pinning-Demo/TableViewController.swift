//
//  TableViewController.swift
//  SSL-Pinning-Demo
//
//  Created by Dmitry Beloborodov on 11/03/2017.
//  Copyright © 2017 Dmitry Beloborodov. All rights reserved.
//

import UIKit
import SWXMLHash

class TableViewController: UITableViewController {

    var currencyList: [Currency] = []

    struct Currency {
        let id: String
        let rate: Double
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        handleRefresh(self.tableView.refreshControl!)
    }

    func handleRefresh(_ refreshControl: UIRefreshControl) {

        let request = URLRequest(url: URL(string: "https://www.bank.lv/vk/ecb.xml")!)
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, error in
            if data != nil {
                let xml = SWXMLHash.parse(data!)
                self.currencyList = []
                for elem in xml["CRates"]["Currencies"]["Currency"] {
                    if let idString = elem["ID"].element?.text,
                        let rateString =  elem["Rate"].element?.text{
                        let currency = Currency(id: idString, rate: Double(rateString)!)
                        self.currencyList.append(currency)
                        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                            self.tableView.reloadData()
                            refreshControl.endRefreshing()
                        })
                    }
                }
            }

            }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let currency = self.currencyList[indexPath.row]
        cell.textLabel?.text = currency.id
        cell.detailTextLabel?.text = String(currency.rate)
        return cell
    }
}
