//
//  EventParser.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class EventParser: IEventParser {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func jsonFromUrlGetter(urlString: String, completion: @escaping (Event?, Error?) -> Void) {
        let decoder = JSONDecoder()
        guard let url = URL(string: urlString) else { fatalError() }
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error)
            } else if let data = data {
                let jsonResponse = try? decoder.decode(Events.self, from: data)
                completion(jsonResponse?.events, nil)
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: nil))
            }
        }
        dataTask.resume()
    }
}
