//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController : CUViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate{
    //MARK: Instance Variables
    private var selectedLevel = Level.one
    private var levels = [MGLLineStyleLayer]()
    private var mapView : MGLMapView!
    private let TABLE_VIEW_CELL_WIDTH = 50
    private let TABLE_VIEW_CELL_HEIGHT = 50
  //  private let NUMBER_OF_FLOORS = 4
    private let viewModel : MapViewModel
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
    init(viewModel: MapViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func select(level : Level){
        self.selectedLevel = level

    }
    var floorOne : MGLLineStyleLayer!
    var floorOutline : MGLLineStyleLayer!
    var roomFill : MGLFillStyleLayer!
    var washroomFill : MGLFillStyleLayer!
    var elevatorFill : MGLFillStyleLayer!
    var hallwayFill : MGLFillStyleLayer!
    var stairsFill : MGLFillStyleLayer!
    var nullFill : MGLFillStyleLayer!

    private func setupLevels(){
        let source = viewModel.shapeSource
        mapView.style?.addSource(source)
        
        floorOutline = MGLLineStyleLayer(identifier: "floor1", source:source)
        floorOutline.predicate = viewModel.linePredicate
        floorOutline.lineWidth = NSExpression(forConstantValue: 0.5)
        floorOutline.lineColor = NSExpression(forConstantValue: UIColor.brown)
        
        roomFill = MGLFillStyleLayer(identifier: "roomFill", source: source)
        roomFill.predicate = viewModel.roomFill
        roomFill.fillColor = NSExpression(forConstantValue: UIColor.blue)
        
        washroomFill = MGLFillStyleLayer(identifier: "washroomFill", source: source)
        washroomFill.predicate = viewModel.washroomFill
        washroomFill.fillColor = NSExpression(forConstantValue: UIColor.orange)
        
        elevatorFill = MGLFillStyleLayer(identifier: "elevatorFill", source: source)
        elevatorFill.predicate = viewModel.elevatorFill
        elevatorFill.fillColor = NSExpression(forConstantValue: UIColor.purple)
        
        hallwayFill = MGLFillStyleLayer(identifier: "hallwayFill", source: source)
        hallwayFill.predicate = viewModel.hallwayFill
        hallwayFill.fillColor = NSExpression(forConstantValue: UIColor.red)
        
        stairsFill = MGLFillStyleLayer(identifier: "stairsFill", source: source)
        stairsFill.predicate = viewModel.stairsFill
        stairsFill.fillColor = NSExpression(forConstantValue: UIColor.yellow)
        
        nullFill = MGLFillStyleLayer(identifier: "nullFill", source: source)
        nullFill.predicate = viewModel.nullFill
        nullFill.fillColor = NSExpression(forConstantValue: UIColor.white)
        
        let labelPredicate = MGLSymbolStyleLayer(identifier: "labels", source: source)
        labelPredicate.predicate = viewModel.labelPredicate
        labelPredicate.text = NSExpression(forKeyPath: "type")
        
    
        mapView.style?.addLayer(nullFill)
        mapView.style?.addLayer(roomFill)
        mapView.style?.addLayer(elevatorFill)
        mapView.style?.addLayer(hallwayFill)
        mapView.style?.addLayer(stairsFill)
        mapView.style?.addLayer(washroomFill)
        mapView.style?.addLayer(floorOutline)
        mapView.style?.addLayer(labelPredicate)
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
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: TABLE_VIEW_CELL_WIDTH, height: TABLE_VIEW_CELL_HEIGHT*Level.allCases.count))
    }
    //MARK: MGLMapViewDelegate Methods
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        setupLevels()
    }
    //MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Level.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(TABLE_VIEW_CELL_HEIGHT)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFloor = Level.allCases.count-indexPath.row
        switch selectedFloor {
        case 1:
            viewModel.currentLevel = .one
            break
        case 2:
            viewModel.currentLevel = .two
        case 3:
            viewModel.currentLevel = .three
        default:
            break
        }
        floorOutline.predicate = NSPredicate(format: "floor = \(Level.allCases.count-indexPath.row)")
        roomFill.predicate = viewModel.roomFill
        washroomFill.predicate = viewModel.washroomFill
        elevatorFill.predicate = viewModel.elevatorFill
        stairsFill.predicate = viewModel.stairsFill
        hallwayFill.predicate = viewModel.hallwayFill
        nullFill.predicate = viewModel.nullFill
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "L\(Level.allCases.count-indexPath.row)"
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
