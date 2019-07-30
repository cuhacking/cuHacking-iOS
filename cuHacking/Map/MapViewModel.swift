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
    var linePredicate : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue)")
        }
    }
    var roomFill : NSPredicate {
        get{
            return  NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'room'")
        }
    }

    var hallwayFill : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'hallway'")
        }
    }
    var washroomFill : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'washroom'")
        }
    }
    var stairsFill : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'stairs'")
        }
    }
    var elevatorFill : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'elevator'")
        }
    }
    var nullFill : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = NULL")
        }
    }
    
    var roomLabelPredicate : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'room'")
        }
    }
    
    var washroomSymbolPredicate : NSPredicate {
        get {
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'washroom'")
        }
    }
    
    var elevatorSymbolPredicate : NSPredicate {
        get {
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'elevator'")
        }
    }
    var stairsSymbolPredicate : NSPredicate {
        get {
            return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'stairs'")
        }
    }
    public init?(mapDataSource: MapDataSource){
        self.currentLevel = .one
        self.mapDataSource = mapDataSource
        let building = try! mapDataSource.loadBuilding(named: "RiverBuilding")
        self.shapeSource = MGLShapeSource(identifier: "RiverBuilding", shape: building, options: nil)
    }
    
}
