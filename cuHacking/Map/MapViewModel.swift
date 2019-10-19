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
        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type != 'backdrop'")
    }
    var backdropPredicate : NSPredicate {
        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'backdrop'")
    }
    var fillFormat : String
    var symbolIconFormat : String
    var labelFormat : String

    public init?(mapDataSource: MapDataSource){
        self.currentLevel = .one
        self.mapDataSource = mapDataSource
        let building = try! mapDataSource.loadBuilding(named: "RiverBuilding")
        self.shapeSource = MGLShapeSource(identifier: "RiverBuilding", shape: building, options: nil)
       
        let fillKeys = ["room","washroom", "elevator", "hallway", "stairs","open"]
        fillFormat =  String.formatMGLMatchExpression(attribute: "type", keys: fillKeys, stringFormat: "%@", includeDefault: true)
        
        let symbolKeys = ["washroom", "elevator","stairs"]
        symbolIconFormat = String.formatMGLMatchExpression(attribute: "type", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
        labelFormat = ""
        
//        labelFormat = String.formatMGLMatchExpression(attribute: "label", keys: [], stringFormat: <#T##String#>, includeDefault: <#T##Bool#>)
        
    }
    
}
