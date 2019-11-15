//
//  TableViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 14/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Dependencies

    let eventParser = EventParser()
    let attributedTextGetter = AttributedTextGetter()
    var givenEvents = [EventDetail]()
    let messageFormatter = MessageFormatter()

    let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&location=moscow&sort_order=popularity"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: apiUrlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }

    @objc func refresh(sender: AnyObject) {
        // Updating data
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonResult = try? decoder.decode(Events.self, from: json) {
                guard let givenEventsTry = jsonResult.events?.event else { return }
                givenEvents = givenEventsTry
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "Please check your connection and try again",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }

    func showEventDetails(title: String, description: String, urlString: String) {
        let url = URL(string: urlString)
        let descriptionFormatter = messageFormatter.messageTextFormatter(line: description)
        let titAndDesc = attributedTextGetter.attributedTextRecieve(title: title, description: descriptionFormatter)

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.setValue(titAndDesc.1, forKey: "attributedMessage")
        actionSheet.setValue(titAndDesc.0, forKey: "attributedTitle")
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            print("Cancel")
        }
        let openLinkActionButton = UIAlertAction(title: "Open link", style: .default, handler: { _ in
            guard let url = url else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            print("Open link")
        })
        actionSheet.addAction(openLinkActionButton)
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return givenEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = givenEvents[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = event.description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Choose action", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Save to favourites", style: .default))
        let showDetailsButton = UIAlertAction(title: "Show details", style: .default, handler: { [weak self] _ in
            guard let title = self?.givenEvents[indexPath.row].title else { return }
            guard let description = self?.givenEvents[indexPath.row].description else { return }
            guard let url = self?.givenEvents[indexPath.row].url else { return }
            self?.showEventDetails(title: title, description: description, urlString: url)
        })
        ac.addAction(showDetailsButton)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(cancelActionButton)
        self.present(ac, animated: true, completion: nil)
    }
}
