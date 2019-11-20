//
//  DetailTableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 19/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var arrayOfBookmarksToShow: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
 //       let title = defaults.string(forKey: "Title")
 //       print(title)
        guard let arrayOfBookmarks = defaults.array(forKey: "ArrayOfBookmarks") else { return }
        arrayOfBookmarksToShow = arrayOfBookmarks as? [(String)] ?? [(String)]()
        for i in arrayOfBookmarksToShow.indices {
            print(arrayOfBookmarks[i])
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfBookmarksToShow.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let contents = arrayOfBookmarksToShow[indexPath.row]
        cell.textLabel?.text = contents
        //cell.detailTextLabel?.text = contents.1
        return cell
    }
}
