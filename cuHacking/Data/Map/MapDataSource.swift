//
//  GeoJSONLoader.swift
//  cuHacking
//
//  Created by Santos on 2019-07-18.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import Foundation
import Mapbox
import SwiftyJSON

class MapDataSource: MapRepository {
    enum Error: Swift.Error {
        case invalidFileName(message: String)
        case invalidGeoJSON(message: String)
        case deserializationFailed(message: String)
    }
    private static let baseURL = Environment.rootURL.absoluteString
    private static let okResponse = 200

    func getMap(completionHandler: @escaping (JSON?, Swift.Error?) -> Void) {
        let baseURL = MapDataSource.baseURL + "/map"
        guard let url = URL(string: baseURL) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                return
            }
            let response = response as? HTTPURLResponse
            if response?.statusCode != MapDataSource.okResponse {
                let error = MagnentonError.fetch(message: "Failed to fetch map. HTTP Response: \(response?.statusCode ?? -1)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                let error = MagnentonError.data(message: "Failed to retrieve data")
                completionHandler(nil, error)
                return
            }
            var map: JSON?

            do {
                map = try JSON(data: data)
                if let cleanString = map?.rawString()?.replacingOccurrences(of: "room-type", with: "roomType"),
                    let cleanData = cleanString.data(using: .utf8){
                    map = try JSON(data: cleanData)
                }
                print(map)
                completionHandler(map, nil)

            } catch {
                completionHandler(nil, error)
                return
            }
        }.resume()
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
