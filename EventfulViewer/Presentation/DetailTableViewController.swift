//
//  DetailTableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 19/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var titleArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let title = titleArray[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
}
