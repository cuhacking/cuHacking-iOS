//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

//Level
//-number
//-geoJSONName


class MapViewController : CUViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate{
    //MARK: Instance Variables
    private var levels = [MGLLineStyleLayer]()
    private var mapView : MGLMapView!
    private let TABLE_VIEW_CELL_WIDTH = 50
    private let TABLE_VIEW_CELL_HEIGHT = 50
    private let NUMBER_OF_FLOORS = 4
    private var currentFloor = 1
    private var numberOfVisibleFloors = 4
    private var tableViewIsExpanded : Bool {
        get{
            return numberOfVisibleFloors != 1
        }
    }
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupFloorPicker()
    }
    
    //MARK: Setup Methods
    private func setupMap(){
        let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.3823547, longitude: -75.6974599), zoomLevel: 17, animated: false)
        view.addSubview(mapView)
    }
    private func show(level : Int){
        switch level {
        case 1:
            levels[0].isVisible = true
            levels[1].isVisible = false
            levels[2].isVisible = false
            levels[3].isVisible = false
            break
        case 2:
            levels[0].isVisible = false
            levels[1].isVisible = true
            levels[2].isVisible = false
            levels[3].isVisible = false

            break
        case 3:
            levels[0].isVisible = false
            levels[1].isVisible = false
            levels[2].isVisible = true
            levels[3].isVisible = false
            break
        case 4:
            levels[0].isVisible = false
            levels[1].isVisible = false
            levels[2].isVisible = false
            levels[3].isVisible = true
        default:
            break
        }
    }
    private func setupLevels(){
        let levelNames = ["LV01", "LV02", "LV03","LV04"]
        for name in levelNames {
            let level = loadLevel(named: name)
            level.isVisible = false
            mapView.style?.addLayer(level)
            levels.append(level)
        }
    }
    
    private func loadLevel(named name: String) -> MGLLineStyleLayer{
        guard let url = Bundle.main.url(forResource: name, withExtension: "geojson")else{
            fatalError("Failed to load Level 1 Data")
        }
        
        guard let data = try? Data(contentsOf: url) else{
            fatalError("Failed to convert geojson to data")
        }
        guard let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else{
            fatalError("Failed to deserialize the GeoJSON Feature Collection")
        }
        let source = MGLShapeSource(identifier: "level-one"+name, shape: shapeCollectionFeature, options: nil)
        mapView.style?.addSource(source)
        //Create strokes
        let outlineLayer = MGLLineStyleLayer(identifier: "room-outlines"+name, source: source)
        outlineLayer.lineWidth = NSExpression(forConstantValue: 0.5)
        outlineLayer.lineColor = NSExpression(forConstantValue: UIColor(named: "CUPurple")!)
        return outlineLayer
    }
   
    private func setupFloorPicker(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: TABLE_VIEW_CELL_WIDTH, height: TABLE_VIEW_CELL_HEIGHT*NUMBER_OF_FLOORS))
    }
    //MARK: MGLMapViewDelegate Methods
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        setupLevels()
//        //read Level data
//        DispatchQueue.global().async {
//            guard let url = Bundle.main.url(forResource: "LV01", withExtension: "geojson")else{
//                fatalError("Failed to load Level 1 Data")
//            }
//
//            guard let data = try? Data(contentsOf: url) else{
//                fatalError("Failed to convert geojson to data")
//            }
//            DispatchQueue.main.async{
//                guard let shapeCollectionFeature = try? MGLShape(data: data, encoding: String.Encoding.utf8.rawValue) as? MGLShapeCollectionFeature else{
//                    fatalError("Failed to deserialize the GeoJSON Feature Collection")
//                }
//                let source = MGLShapeSource(identifier: "level-one", shape: shapeCollectionFeature, options: nil)
//                mapView.style?.addSource(source)
//
//                //Create strokes
//                let outlineLayer = MGLLineStyleLayer(identifier: "room-outlines", source: source)
//               // outlineLayer.predicate = NSPredicate(format: "type = 'room'")
//                outlineLayer.lineWidth = NSExpression(forConstantValue: 0.5)
//                outlineLayer.lineColor = NSExpression(forConstantValue: UIColor.black)
//                mapView.style?.addLayer(outlineLayer)
//            }
//        }
    }
    //MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfVisibleFloors
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TABLE_VIEW_CELL_HEIGHT)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected:\(indexPath.row)")
        show(level: NUMBER_OF_FLOORS - indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "L\(NUMBER_OF_FLOORS-indexPath.row)"
        cell.textLabel?.textAlignment = .center
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(named: "CUPurple")
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    //MARK: iOS 13 Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if(previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == false){
                return
            }
            let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
            mapView.styleURL = url
        }
    }
}
