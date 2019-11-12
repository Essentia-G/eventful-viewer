//
//  Assembly.swift
//  EventfulViewer
//
//  Created by Станислава on 25/10/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

class Assembly {
    let eventParser: EventParserProtocol
   // let eventParserService: IEventParserService

    init() {
        let session = URLSession.shared
        let eventParser = EventParser()
        self.eventParser = eventParser
        //self.eventParserService = EventParserServise(eventParser: eventParser)
    }
}
