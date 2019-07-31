//
//  MapViewModel.swift
//  cuHacking
//
//  Created by Santos on 2019-07-15.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
class MapViewModel {
    
    private let mapDataSource : MapDataSource
    let shapeSource: MGLShapeSource
    var currentLevel : Level
    var floorPredicate : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue)")
        }
    }
    var fillFormat : String
    var symbolIconFormat : String

    public init?(mapDataSource: MapDataSource){
        self.currentLevel = .one
        self.mapDataSource = mapDataSource
        let building = try! mapDataSource.loadBuilding(named: "RiverBuilding")
        self.shapeSource = MGLShapeSource(identifier: "RiverBuilding", shape: building, options: nil)
       
        let fillKeys = ["room","washroom", "elevator", "hallway", "stairs"]
        fillFormat =  String.formatMGLMatchExpression(attribute: "type", keys: fillKeys, stringFormat: "%@", includeDefault: true)
        
        let symbolKeys = ["washroom", "elevator","stairs"]
        symbolIconFormat = String.formatMGLMatchExpression(attribute: "type", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
    }
    
}
