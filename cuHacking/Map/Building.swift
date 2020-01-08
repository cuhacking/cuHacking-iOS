//
//  Building.swift
//  cuHacking
//
//  Created by Santos on 2020-01-08.
//  Copyright © 2020 cuHacking. All rights reserved.
//

import Foundation
import Mapbox

final class Building {
    struct Floor {
        let id: String
        let name: String
    }
    let name: String
    let shapeSource: MGLShapeSource
    var currentLevel: Level
    var floorPredicate: NSPredicate {
        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type != 'backdrop'")
    }
    var backdropPredicate: NSPredicate {
        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'backdrop'")
    }
    var fillFormat: String
    var symbolIconFormat: String
    var labelFormat: String

    let center: CGPoint
    let floors: [Floor]
    init(named name: String, featureCollection building: MGLShapeCollectionFeature, center: CGPoint, floors: [Floor]) {
        self.center = center
        self.floors = floors
        self.name = name

        self.currentLevel = .one
        self.shapeSource = MGLShapeSource(identifier: name, shape: building, options: nil)

        let fillKeys = ["room", "washroom", "elevator", "hallway", "stairs", "open"]
        fillFormat =  String.formatMGLMatchExpression(attribute: "type", keys: fillKeys, stringFormat: "%@", includeDefault: true)

        let symbolKeys = ["washroom", "elevator", "stairs"]
        symbolIconFormat = String.formatMGLMatchExpression(attribute: "type", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
        labelFormat = ""
    }
}
