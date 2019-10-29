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
    
    let regionRadius: CLLocationDistance = 1000
    
    let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=music&location=london&sort_order=popularity"
    //var event = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial location in London
        let initialLocation = CLLocation(latitude: 51.509865, longitude: -0.118092)
        centerMapOnLocation(location: initialLocation)
        
        //show hardcoded pin on map
//        let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: 51.5009088, longitude: -0.177366), title: "Zucchero", subtitle: "Zucchero")
//        mapKitView.addAnnotation(mapPin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configButton()
        
//        let annotation = MKPointAnnotation()
//        annotation.title = "Test test"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.50, longitude: -0.17)
  
        //mapKitView?.addAnnotation(annotation)
    }
    
    func configButton() {
        searchButton.imageView?.contentMode = .scaleAspectFit
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapKitView.setRegion(coordinateRegion, animated: true)
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
        DispatchQueue.global().async { [weak self] in
            let decoder = JSONDecoder()
            
            let jsonEvents = try? decoder.decode(Events.self, from: json)
            print(jsonEvents?.events?.event[0] ?? "Have no events")
            
            guard let eventsToPin = jsonEvents?.events?.event else { return }
         
                for i in eventsToPin.indices {
                    print(eventsToPin[i].title)
                    let lat = self?.receiveAPICoordinates(from: jsonEvents?.events?.event[i].latitude ?? "0.0")
                    let long = self?.receiveAPICoordinates(from: jsonEvents?.events?.event[i].longitude ?? "0.0")
                    let tit = jsonEvents?.events?.event[i].title
                    
                    guard let latitide = lat, let longitude = long, let title = tit else { return }
                    
                    let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitide, longitude: longitude), title: title)
                    self?.mapKitView.addAnnotation(mapPin)
                }
            
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    func receiveAPICoordinates(from strCoordinates: String) -> Double? {
        let doubCoordinates = Double(strCoordinates)
        return doubCoordinates
    }
    
}
    



