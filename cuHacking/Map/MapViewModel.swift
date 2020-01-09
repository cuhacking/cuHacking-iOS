//
//  MapViewModel.swift
//  cuHacking
//
//  Created by Santos on 2019-07-15.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
import SwiftyJSON

class MapViewModel {
//    private let mapDataSource: MapDataSource
//    let shapeSource: MGLShapeSource
//    var currentLevel: Level
//    var floorPredicate: NSPredicate {
//        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type != 'backdrop'")
//    }
//    var backdropPredicate: NSPredicate {
//        return NSPredicate(format: "floor = \(currentLevel.rawValue) AND type = 'backdrop'")
//    }
//    var fillFormat: String
//    var symbolIconFormat: String
//    var labelFormat: String
    var buildings: [Building] = []

    public static func create(dataSource: MapRepository = MapDataSource(), completionHandler: @escaping(MapViewModel?, Error?) -> Void) {
        let mapViewModel = MapViewModel()
        dataSource.getMap { (json, error) in
            if error != nil {
                print(error?.localizedDescription)
                completionHandler(nil, error)
                return
            }
            guard let json = json else {
                return
            }
            for (key, buildingJSON):(String, JSON) in json["map"]["map"] {
                do {
                    let buildingData = try buildingJSON["geometry"].rawData()
                    if let shapeCollectionFeature = try MGLShape(data: buildingData, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature {
                        let center = CLLocationCoordinate2D(latitude: Double(buildingJSON["center"][0].intValue),
                                                              longitude: Double(buildingJSON["center"][1].intValue))
                        var floors: [Building.Floor] = []
                        for(_, floorJSON):(String, JSON) in buildingJSON["floors"] {
                            floors.append(Building.Floor(id: floorJSON["id"].stringValue, name: floorJSON["name"].stringValue))
                        }
                        let building = Building(named: key, featureCollection: shapeCollectionFeature, center: center, floors: floors)
                        mapViewModel.buildings.append(building)
                    }
                } catch {
                    
                }
            }
            completionHandler(mapViewModel, nil)
            
        }
    }

}
