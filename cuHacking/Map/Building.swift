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
    var currentFloor: Floor?
    var backdropLinePredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'backdrop-line'")
    }
    var symbolPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND label = TRUE")
    }
    var linePredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'line'")
    }
    var floorPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'room'")
    }
    var backdropPredicate: NSPredicate {
        return NSPredicate(format: "floor = '\(currentFloor?.id ?? "")' AND type = 'backdrop'")
    }
    var fillFormat: String
    var symbolIconFormat: String
    var labelFormat: String

    let center: CLLocationCoordinate2D
    let floors: [Floor]
    init(named name: String, featureCollection building: MGLShapeCollectionFeature, center: CLLocationCoordinate2D, floors: [Floor]) {
        self.center = center
        self.floors = floors
        self.name = name
        self.shapeSource = MGLShapeSource(identifier: name, shape: building, options: nil)

        let fillKeys = ["room", "washroom", "elevator", "hallway", "stairs"]

        fillFormat =  String.formatMGLMatchExpression(attribute: "roomType", keys: fillKeys, stringFormat: "%@", includeDefault: true)
        let symbolKeys = ["washroom", "elevator", "stairs"]

        symbolIconFormat = String.formatMGLMatchExpression(attribute: "roomType", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
        labelFormat = ""
        if let firstFloor = floors.first {
            currentFloor = firstFloor
        }
    }
    private func floor(named name: String) -> Floor? {
        for floor in floors where floor.name == name {
            return floor
        }
        return nil
    }
}
