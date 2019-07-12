//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController : CUViewController, UITableViewDataSource, UITableViewDelegate{
    //MARK: Instance Variables
    private var mapView : MGLMapView!
    
    private let NUMBER_OF_FLOORS = 4
    private var currentFloor = 1
    private var numberOfVisibleFloors = 1
    
    private var tableView : UITableView = {
        let tableView = UITableView()
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
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.3823547, longitude: -75.6974599), zoomLevel: 17, animated: false)
        view.addSubview(mapView)
        
    }
    private func setupFloorPicker(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: 50, height: 50))
    }
    
    //MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfVisibleFloors
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "L\(indexPath.row+1)"
        cell.textLabel?.textAlignment = .center
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
