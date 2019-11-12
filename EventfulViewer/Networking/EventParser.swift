//
//  EventParser.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import UIKit

class EventParser: EventParserProtocol {

    func jsonFromUrlGetter(url: URL, completion: @escaping (Event?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let jsonEvents = try? decoder.decode(Events.self, from: data)
            completion(jsonEvents?.events, nil)
            print(jsonEvents?.events?.event[0] ?? "Have no events")
        }.resume()
    }
}
