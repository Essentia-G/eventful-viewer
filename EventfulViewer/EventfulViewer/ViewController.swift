//
//  ViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 24/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapKitView: MKMapView!
    
    //let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=music&location=london&sort_order=popularity"
  
    
    let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=music&location=london&sort_order=popularity"
    //var event = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configButton()
    }
    
    func configButton() {
        searchButton.imageView?.contentMode = .scaleAspectFit
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: apiUrlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            
            guard let self = self, let data = data else { return }

            self.parse(json: data)
        }.resume()
//        if let url = URL(string: apiUrlString) {
//            //convert url to data instance
//            if let data = try? Data(contentsOf: url) {
//                //we're OK to parse data
//                parse(json: data)
//            } else {
//                showError()
//            }
//        } else {
//            showError()
//        }
    }
    
//    func parse(json: Data) {
//        DispatchQueue.global().async { [weak self] in
//            let decoder = JSONDecoder()
//            if let jsonEvents = try? decoder.decode(Events.self, from: json) {
//                self?.event = jsonEvents.events
//            }
//        }
//    }
    
    func parse(json: Data) {
        DispatchQueue.global().async {
            let decoder = JSONDecoder()
            let jsonEvents = try? decoder.decode(Events.self, from: json)
            print(jsonEvents?.events?.event[0].id ?? "Have no events")
            //let event = jsonEvents?.events
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
}
    



