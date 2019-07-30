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
    private var levels = [MGLLineStyleLayer]()
    private var mapView : MGLMapView!
    private let TABLE_VIEW_CELL_WIDTH = 50
    private let TABLE_VIEW_CELL_HEIGHT = 50
    private let viewModel : MapViewModel
    private var floorOutline : MGLLineStyleLayer!
    private var roomLabelLayer, washroomSymbolLayer, stairsSymbolLayer, elevatorSymbolLayer  : MGLSymbolStyleLayer!
    private var roomFill, washroomFill, elevatorFill, hallwayFill, stairsFill, nullFill : MGLFillStyleLayer!
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

    private func setupLevels(){
        let source = viewModel.shapeSource
        
        floorOutline = MGLLineStyleLayer(identifier: "floor1", source:source)
        floorOutline.lineWidth = NSExpression(forConstantValue: 0.5)
        floorOutline.lineColor = NSExpression(forConstantValue: UIColor.brown)
        
        roomFill = MGLFillStyleLayer(identifier: "roomFill", source: source)
        roomFill.fillColor = NSExpression(forConstantValue: UIColor.blue)
        
        washroomFill = MGLFillStyleLayer(identifier: "washroomFill", source: source)
        washroomFill.fillColor = NSExpression(forConstantValue: UIColor.orange)
        
        elevatorFill = MGLFillStyleLayer(identifier: "elevatorFill", source: source)
        elevatorFill.fillColor = NSExpression(forConstantValue: UIColor.purple)
        
        hallwayFill = MGLFillStyleLayer(identifier: "hallwayFill", source: source)
        hallwayFill.fillColor = NSExpression(forConstantValue: UIColor.red)
        
        stairsFill = MGLFillStyleLayer(identifier: "stairsFill", source: source)
        stairsFill.fillColor = NSExpression(forConstantValue: UIColor.yellow)
        
        nullFill = MGLFillStyleLayer(identifier: "nullFill", source: source)
        nullFill.fillColor = NSExpression(forConstantValue: UIColor.white)
        
        roomLabelLayer = MGLSymbolStyleLayer(identifier: "roomLabelLayer", source: source)
        roomLabelLayer.textFontSize = NSExpression(forConstantValue: 10)
        roomLabelLayer.text = NSExpression(forKeyPath: "room")
        
        washroomSymbolLayer = MGLSymbolStyleLayer(identifier: "washroomSymbolLayer", source: source)
        washroomSymbolLayer.iconImageName = NSExpression(forConstantValue: "washroom")
        washroomSymbolLayer.iconScale = NSExpression(forConstantValue: 0.1)
        washroomSymbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 10)))
        washroomSymbolLayer.text = NSExpression(forKeyPath: "room")
        washroomSymbolLayer.textFontSize = NSExpression(forConstantValue: 8)
        
        elevatorSymbolLayer = MGLSymbolStyleLayer(identifier: "elevatorSymbolLayer", source: source)
        elevatorSymbolLayer.iconImageName = NSExpression(forConstantValue: "elevator")
        elevatorSymbolLayer.iconScale = NSExpression(forConstantValue: 0.15)
//        elevatorSymbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 10)))
//        elevatorSymbolLayer.text = NSExpression(forKeyPath: "room")
//        elevatorSymbolLayer.textFontSize = NSExpression(forConstantValue: 8)
        
        stairsSymbolLayer = MGLSymbolStyleLayer(identifier: "stairsSymbolLayer", source: source)
        stairsSymbolLayer.iconImageName = NSExpression(forConstantValue: "stairs")
        stairsSymbolLayer.iconScale = NSExpression(forConstantValue: 0.1)
        stairsSymbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 10)))
        stairsSymbolLayer.text = NSExpression(forKeyPath: "room")
        stairsSymbolLayer.textFontSize = NSExpression(forConstantValue: 8)
        
        updateMapPredicates()

        mapView.style?.addSource(source)
        mapView.style?.addLayer(nullFill)
        mapView.style?.addLayer(roomFill)
        mapView.style?.addLayer(elevatorFill)
        mapView.style?.addLayer(hallwayFill)
        mapView.style?.addLayer(stairsFill)
        mapView.style?.addLayer(washroomFill)
        mapView.style?.addLayer(floorOutline)
        mapView.style?.addLayer(roomLabelLayer)
        mapView.style?.addLayer(washroomSymbolLayer)
        mapView.style?.addLayer(elevatorSymbolLayer)
        mapView.style?.addLayer(stairsSymbolLayer)
    }
    
    private func setupFloorPicker(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: TABLE_VIEW_CELL_WIDTH, height: TABLE_VIEW_CELL_HEIGHT*Level.allCases.count))
    }
    
    private func updateMapPredicates(){
        floorOutline.predicate = viewModel.linePredicate
        roomLabelLayer.predicate = viewModel.roomLabelPredicate
        roomFill.predicate = viewModel.roomFill
        washroomFill.predicate = viewModel.washroomFill
        elevatorFill.predicate = viewModel.elevatorFill
        stairsFill.predicate = viewModel.stairsFill
        hallwayFill.predicate = viewModel.hallwayFill
        nullFill.predicate = viewModel.nullFill
        washroomSymbolLayer.predicate = viewModel.washroomSymbolPredicate
        elevatorSymbolLayer.predicate = viewModel.elevatorSymbolPredicate
        stairsSymbolLayer.predicate = viewModel.stairsSymbolPredicate
    }
    //MARK: MGLMapViewDelegate Methods
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        mapView.style?.setImage(UIImage(named: "washroom")!, forName: "washroom")
        mapView.style?.setImage(UIImage(named: "elevator")!, forName: "elevator")
        mapView.style?.setImage(UIImage(named: "stairs")!, forName: "stairs")
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
        viewModel.currentLevel = (Level.allCases.count-indexPath.row).toLevel()
        updateMapPredicates()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == Level.allCases.count-1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
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
