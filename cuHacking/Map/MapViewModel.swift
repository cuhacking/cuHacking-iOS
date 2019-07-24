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
    var labelPredicate : NSPredicate {
        get{
            return NSPredicate(format: "floor = \(currentLevel.rawValue)")
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
    
    public init?(mapDataSource: MapDataSource){
        self.currentLevel = .one
        self.mapDataSource = mapDataSource
        let building = try! mapDataSource.loadBuilding(named: "RiverBuilding")
        self.shapeSource = MGLShapeSource(identifier: "RiverBuilding", shape: building, options: nil)
        print("CURRENT LEVEL\(currentLevel.rawValue)")

//        self.roomFill = NSPredicate(format: "type = room")
//        self.hallwayFill = NSPredicate(format: "type = hallway")
//        self.washroomFill = NSPredicate(format: "type = washroom")
//        self.stairsFill = NSPredicate(format: "type = stairs")
//        self.elevatorFill = NSPredicate(format: "floor = 2 AND type = washroom")
//        self.nullFill = NSPredicate(format: "type = null")
    }
    
}
