//
//  EventParserService.swift
//  EventfulViewer
//
//  Created by Станислава on 08/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

class EventParserServise: IEventParserService {

    private let eventParser: IEventParser

    init(eventParser: IEventParser) {
        self.eventParser = eventParser
    }

    func loadEvent(urlString: String, completion: @escaping ((Event?, Error?) -> Void)) {
        eventParser.jsonFromUrlGetter(urlString: urlString) { eventDetail, error in
            if error != nil {
                completion(nil, error)
            } else if let eventDetail = eventDetail {
                completion(eventDetail, nil)
            } else {
                completion(nil, NSError(domain: "", code: 0, userInfo: nil))
            }
        }
    }
}
