//
//  GeoJSONLoader.swift
//  cuHacking
//
//  Created by Santos on 2019-07-18.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox

class MapDataSource {
    enum Error: Swift.Error {
        case invalidFileName(message: String)
        case invalidGeoJSON(message: String)
        case deserializationFailed(message: String)
    }

    /// Loads a GeoJSON file
    /// - Parameter name: name of the geoJSON file representing a building 
    func loadBuilding(named name: String) throws -> MGLShapeCollectionFeature {
        guard let url = Bundle.main.url(forResource: name, withExtension: "geojson") else {
           throw MapDataSource.Error.invalidFileName(message: "\(name).geojson not found in bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            throw MapDataSource.Error.invalidGeoJSON(message: "\(name).geojson could not be turned into data.")
        }

        guard let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else {
            throw MapDataSource.Error.deserializationFailed(message: "Failed to deserialize \(name).geojson into a MGLShapeCollectionFeature")
        }
        return shapeCollectionFeature
    }
}
