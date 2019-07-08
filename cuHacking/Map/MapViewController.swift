//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController : CUViewController{
    private var mapView : MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.3823547, longitude: -75.6974599), zoomLevel: 17, animated: false)
        view.addSubview(mapView)
    }
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
