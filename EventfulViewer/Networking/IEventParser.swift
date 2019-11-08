//
//  IEventParser.swift
//  EventfulViewer
//
//  Created by Станислава on 08/11/2019.
//  Copyright © 2019 Stminchuk. All rights reserved.
//

import Foundation

protocol IEventParser {

    func jsonFromUrlGetter(urlString: String, completion: @escaping (Event?, Error?) -> Void)

}
