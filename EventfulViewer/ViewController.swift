//
//  ViewController.swift
//  EventfulViewer
//
//  Created by Станислава on 24/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapKitView: MKMapView!

    let regionRadius: CLLocationDistance = 2000

    let apiUrlString = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=music&location=london&sort_order=popularity"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        mapKitView.delegate = self

        // set initial location in London
        let initialLocation = CLLocation(latitude: 51.509865, longitude: -0.118092)
        centerMapOnLocation(location: initialLocation)

        guard let url = URL(string: apiUrlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in

            guard let self = self, let data = data else { return }

            self.parse(json: data)
            }.resume()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        configButton()

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

        if !searchField.text!.isEmpty {
            if let eventCategory = searchField.text {
                let annotationsToRemove = mapKitView.annotations.filter { $0 !== mapKitView.userLocation }
                mapKitView.removeAnnotations(annotationsToRemove)
                let desirableUrl = "http://api.eventful.com/json/events/search?app_key=PN85FnVbJXZCWxP3&category=" + eventCategory + "&location=london&sort_order=popularity"
                guard let url = URL(string: desirableUrl) else { return }
                URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in

                    guard let self = self, let data = data else { return }
                    self.parse(json: data)
                    }.resume()
            }
            searchField.text?.removeAll()
        } else {
            let alertController = UIAlertController(title: "Field is empty",
                                       message: "Please enter your text",
                                       preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }

    }

    func parse(json: Data) {
        DispatchQueue.global().async { [weak self] in
            let decoder = JSONDecoder()

            let jsonEvents = try? decoder.decode(Events.self, from: json)
            print(jsonEvents?.events?.event[0] ?? "Have no events")

            guard let eventsToPin = jsonEvents?.events?.event else { return }

                for index in eventsToPin.indices {
                    print(eventsToPin[index].title)
                    let latitudeAttempt = self?.receiveAPICoordinates(from:
                        jsonEvents?.events?.event[index].latitude ?? "0.0")
                    let longitudeAttempt = self?.receiveAPICoordinates(from:
                        jsonEvents?.events?.event[index].longitude ?? "0.0")
                    let titleAttempt = jsonEvents?.events?.event[index].title
                    let descsriptionAttempt = jsonEvents?.events?.event[index].description
                    let urlAttempt = NSURL(string: jsonEvents?.events?.event[index].url ?? "")

                    if let image = jsonEvents?.events?.event[index].image {
                        print(image.url)
                    }

                    guard let latitide = latitudeAttempt,
                        let longitude = longitudeAttempt,
                        let title = titleAttempt,
                        let descript = descsriptionAttempt,
                        let url = urlAttempt else { return }

                    let mapPin = MapPin(coordinate: CLLocationCoordinate2D(latitude: latitide,
                                                                           longitude: longitude),
                                        title: title,
                                        descript: descript,
                                        url: url as URL)
                    self?.mapKitView.addAnnotation(mapPin)

                }
        }
    }

    func receiveAPICoordinates(from strCoordinates: String) -> Double? {
        let doubCoordinates = Double(strCoordinates)
        return doubCoordinates
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let eventAnnotation = view.annotation as? MapPin {
            let title = eventAnnotation.title
            var descript = eventAnnotation.descript
            descript = messageTextFormatter(line: descript ?? "")
            let url = eventAnnotation.url
            print(title ?? "" + "\n")
            print(descript ?? "")

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.justified

            let attributedMessageText = NSMutableAttributedString(
                string: descript ?? "",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)
                ]
            )

            let titleFont = [NSAttributedString.Key.font: UIFont(name: "ArialHebrew-Bold", size: 18.0)!]
            let attributedTitleText = NSMutableAttributedString(string: title ?? "", attributes: titleFont)

            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.setValue(attributedMessageText, forKey: "attributedMessage")
            actionSheet.setValue(attributedTitleText, forKey: "attributedTitle")

            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
                print("Cancel")
            }
            let openLinkActionButton = UIAlertAction(title: "Open link", style: .default, handler: { _ in
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                NSLog("Open link")
            })
            actionSheet.addAction(openLinkActionButton)
            actionSheet.addAction(cancelActionButton)
            self.present(actionSheet, animated: true, completion: nil)
        }

        //guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") else { return }
        //self.present(vc, animated: true, completion: nil)
    }

    func messageTextFormatter(line: String) -> String {
        if line.contains("<p>") {
            var newLine = line.replacingOccurrences(of: "<p>", with: "")
            newLine = newLine.replacingOccurrences(of: "</p>", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return newLine
        } else {
        return line
    }
    }

    func showError() {
        let alertController = UIAlertController(title: "Loading error",
                                                message: "Please check your connection and try again",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

 }

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
