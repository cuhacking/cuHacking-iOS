//
//  MapRepostiroy.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
protocol MapRepository {
    func getMap(completionHandler: @escaping ([String: Any]?, Error?) -> Void)
}
