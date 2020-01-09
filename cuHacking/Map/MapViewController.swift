//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate {
    // MARK: Instance Variables
    private var viewModel: MapViewModel?
    private var levelsAdded = false
    private var cardViewController: CardViewController!
    private var visualEffectView: UIVisualEffectView!
    private let cardHeight: CGFloat = 350
    private var cardVisible = false
    private var cardNextStae: CardState {
        return cardVisible ? .expanded : .collapsed
    }
    private var runningCardAnimations = [UIViewPropertyAnimator]()
    private var cardAnimationProgressWhenInterrupted: CGFloat = 0
    private var levels = [MGLLineStyleLayer]()
    private var mapView: MGLMapView!
    private let tableViewCellWidth = 50
    private let tableViewCellHeight = 50
    private var lineLayer: MGLLineStyleLayer!
    private var fillLayer, backdropLayer: MGLFillStyleLayer!
    private var symbolLayer: MGLSymbolStyleLayer!
   
    private var lineLayers: [String: MGLLineStyleLayer] = [:]
    private var fillLayers: [String: MGLFillStyleLayer] = [:]
    private var backdropLayers: [String: MGLFillStyleLayer] = [:]
    private var backdropLineLayers: [String: MGLLineStyleLayer] = [:]
    private var symbolLayers: [String: MGLSymbolStyleLayer] = [:]
    
    var closestBuilding: Building? {
        guard let buildings = viewModel?.buildings,
            let firstBuilding = buildings.first else {
            return nil
        }
//        let mainPoint = mapView.centerCoordinate
        let point = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        var shortestDistance = point.distance(from: firstBuilding.center)
        var closestBuilding = firstBuilding
        buildings.forEach { (building) in
            print("Main:\(point.coordinate.latitude), Long\(point.coordinate.longitude)")
            print("Lat:\(building.center.coordinate.latitude), Long\(building.center.coordinate.longitude)")

            let distance = point.distance(from: building.center)
            if distance < shortestDistance {
                shortestDistance = distance
                closestBuilding = building
            }
        }
//        let distance = CLLocationCoordinate2D(latitude: -75.696548, longitude: 45.383211)
//        let work = CLLocationCoordinate2D(latitude: -75.69626, longitude: 45.382349)
//        let lit = [distance, work]
//        var x = distance
//        var one = mainPoint.distance(to: distance)
//        lit.forEach { (point) in
//            let distance = mainPoint.distance(to: point)
//            if distance < one {
//                one = distance
//                x = point
//            }
//        }
//        print("THR BEST\(x.latitude)")
//        print("work\(distance.distance(to: work))")
//        print("main point'\(mainPoint.latitude)")
        return closestBuilding
//        print(mainPoint.latitude)
//        var lowestDistance = mainPoint.distanceSquared(to: firstBuilding.center)
//        var closestBuilding = firstBuilding
//
////        buildings.forEach { (building) in
//            let currentDistance = mainPoint.distanceSquared(to: buildings[1].center)
////            print("Nam:\(building.name), \(lowestDistance)+\(currentDistance)")
//            if currentDistance < lowestDistance {
//                lowestDistance = currentDistance
//                closestBuilding = buildings[1]
//            }
////        }
//        print("lats:\(firstBuilding.center.latitude)")
//        print("difference:\(firstBuilding.center.latitude - buildings[1].center.latitude)))")
//        return closestBuilding
    }
    

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  Asset.Colors.background.color
        
        MapViewModel.create { [weak self] (mapViewModel, error) in
            guard let self = self else {
                return
            }
            if error != nil {
                print(error?.localizedDescription)
            }
            self.viewModel = mapViewModel
            DispatchQueue.main.async {
                self.setupMap()
                self.setupFloorPicker()
                self.setupCard()
            }
        }
    }

    // MARK: Setup Methods
    private func setupMap() {
        let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL

        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.3823547, longitude: -75.6974599), zoomLevel: 19, animated: false)
        
//        let singleTap = UITapGestureRecognizer(target: self, action: #selector(roomTapped(sender:)))
//        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
//            singleTap.require(toFail: recognizer)
//        }
//
//        mapView.addGestureRecognizer(singleTap)
        view.addSubview(mapView)
    }
    private func setupLevels(forBuilding building: Building) {
        guard let style = self.mapView.style else { return }

        let source = building.shapeSource
        style.addSource(source)

        let backdropLayer = MGLFillStyleLayer(identifier: "\(building.name)-backdrop-layer", source: source)
        backdropLayer.fillColor = NSExpression(forConstantValue: Asset.Colors.backdrop.color)

        let backdropLineLayer = MGLLineStyleLayer(identifier: "\(building.name)-backdrop-line-layer", source: source)
        backdropLineLayer.lineWidth = NSExpression(forConstantValue: 5)
        backdropLineLayer.lineColor = NSExpression(forConstantValue: Asset.Colors.line.color)

        let lineLayer = MGLLineStyleLayer(identifier: "\(building.name)-line-layer", source: source)
        lineLayer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",[18: 0, 19: 3])
        lineLayer.lineColor = NSExpression(forConstantValue: Asset.Colors.line.color)
        let fillLayer = MGLFillStyleLayer(identifier: "\(building.name)-fill-layer", source: source)
        let defaultFill = UIColor.green
        fillLayer.fillColor = NSExpression(format: building.fillFormat,
                                           Asset.Colors.blue1.color,
                                           Asset.Colors.washroom.color,
                                           Asset.Colors.elevator.color,
                                           Asset.Colors.hallway.color,
                                           Asset.Colors.stairs.color,
                                           defaultFill)
        //NSExpression(format: "TERNARY(booleanProperty=YES, %@, MGL_MATCH(type, 'type1', %@, 'type2', %@, 'type3', %@, %@))", UIColor.red, UIColor.orange, UIColor.purple, UIColor.yellow, defaultColor)
//        let symbolKeys = ["stairs", "elevator"]
//        let noString = String.formatMGLMatchExpression(attribute: "roomType", keys: symbolKeys, stringFormat: "%@", includeDefault: true)
//        symbolLayer.iconImageName = NSExpression(format: "TERNARY(roomType == washroom, %@, \(noString))", "stairs", "stairs", "washroom", "")
        let symbolLayer = MGLSymbolStyleLayer(identifier: "\(building.name)-symbol-layer", source: source)
        symbolLayer.iconImageName = NSExpression(format: building.symbolIconFormat, "washroom", "elevator", "stairs", "")
        symbolLayer.minimumZoomLevel = 19
        symbolLayer.iconScale = NSExpression(forConstantValue: 0.2)
        symbolLayer.text = NSExpression(forKeyPath: "name")
        symbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 22)))
        symbolLayer.textFontSize = NSExpression(forConstantValue: 16)

        style.addLayer(backdropLayer)
        style.addLayer(backdropLineLayer)
        style.addLayer(fillLayer)
        style.addLayer(symbolLayer)
        style.addLayer(lineLayer)

        backdropLayers[building.name] = backdropLayer
        backdropLineLayers[building.name] = backdropLineLayer
        fillLayers[building.name] = fillLayer
        symbolLayers[building.name] = symbolLayer
        lineLayers[building.name] = lineLayer
        updatePredicates(forBuilding: building)
    }

    private func updatePredicates(forBuilding building: Building) {
        backdropLayers[building.name]?.predicate = building.backdropPredicate
        backdropLineLayers[building.name]?.predicate = building.backdropLinePredicate
        lineLayers[building.name]?.predicate = building.linePredicate
        fillLayers[building.name]?.predicate = building.floorPredicate
        symbolLayers[building.name]?.predicate = building.symbolPredicate
    }
    private var floorPickerHeightAnchor: NSLayoutConstraint!
    private func setupFloorPicker() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.widthAnchor.constraint(equalToConstant: 40)
        ])
        var height = tableViewCellHeight
        if let closestBuilding = closestBuilding {
            height = tableViewCellHeight*closestBuilding.floors.count
        }
        floorPickerHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        floorPickerHeightAnchor.isActive = true
//        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: tableViewCellWidth, height: tableViewCellHeight*Level.allCases.count))
    }

    private func setupCard() {
//        visualEffectView = UIVisualEffectView(frame: self.view.frame)
//        self.view.addSubview(visualEffectView)
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
        cardViewController.view.clipsToBounds = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.handleCardPan(recognizer:)))
        cardViewController.view.addGestureRecognizer(panGesture)
        self.view.addSubview(cardViewController.view)
    }

    func hideCard() {
        let frameAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.cardViewController.view.frame.origin.y = self.view.frame.height
        }
        frameAnimator.startAnimation()
    }

    func showCard() {
        let frameAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.cardViewController.view.frame.origin.y = self.view.bounds.height-self.cardHeight
        }
        frameAnimator.startAnimation()
        frameAnimator.addCompletion { (_) in
            self.originalCenterY = self.cardViewController.view.center.y
        }
    }

    var originalCenterY: CGFloat = 0
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if translation.y < 0 { return }
        let newCenter = translation.y+originalCenterY
        switch recognizer.state {
        case .began, .changed:
            self.cardViewController.view.center.y = newCenter
        case .ended, .cancelled, .failed:
            if originalCenterY/newCenter <= 0.90 {
                hideCard()
            } else {
                self.cardViewController.view.center.y = originalCenterY
            }
        default:
            break
        }
    }

    private func animateCardTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningCardAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            frameAnimator.addCompletion { (_) in
                self.cardVisible = !self.cardVisible
                self.runningCardAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            runningCardAnimations.append(frameAnimator)
        }
    }
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningCardAnimations.isEmpty {
            //run animations
            animateCardTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningCardAnimations {
            animator.pauseAnimation() //sets speed to 0 (making it interactive)
            cardAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    private func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningCardAnimations {
            animator.fractionComplete = fractionCompleted
        }
    }
    private func continueInteractiveTransition() {
        for animator in runningCardAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

    private func updateMapPredicates() {
//        backdropLayer.predicate = viewModel.backdropPredicate
//        lineLayer.predicate = viewModel.floorPredicate
//        fillLayer.predicate = viewModel.floorPredicate
//        symbolLayer.predicate = viewModel.floorPredicate
    }

    @objc func roomTapped(sender: UITapGestureRecognizer) {
        let spot = sender.location(in: mapView)
        if let room = mapView.visibleFeatures(at: spot).last {
            print(room)
            cardViewController.titleLabel.text = room.attributes["room"] as? String ?? ""
            showCard()
        }
    }

    // MARK: MGLMapViewDelegate Methods
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        print("loaded")
        mapView.style?.setImage(Asset.Images.washroom.image, forName: "washroom")
        mapView.style?.setImage(Asset.Images.elevator.image, forName: "elevator")
        mapView.style?.setImage(Asset.Images.stairs.image, forName: "stairs")
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        //setupLevels()
        guard let viewModel = self.viewModel else {
            return
        }
        viewModel.buildings.forEach { (building) in
            setupLevels(forBuilding: building)
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        print("new center:\(self.mapView.centerCoordinate)")
        tableView.reloadData()
    }
    
    // MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let closestBuilding = closestBuilding else {
            return 0
        }
        floorPickerHeightAnchor.constant = CGFloat(tableViewCellHeight*closestBuilding.floors.count)
        return closestBuilding.floors.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewCellHeight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let closestBuilding = closestBuilding else {
            return
        }
        closestBuilding.currentFloor = closestBuilding.floors[indexPath.row]
        updatePredicates(forBuilding: closestBuilding)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let closestBuilding = closestBuilding, indexPath.row == closestBuilding.floors.count-1 {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let closestBuilding = closestBuilding else {
            return UITableViewCell()
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(closestBuilding.floors[indexPath.row].name)"
        cell.textLabel?.textAlignment = .center
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor =  Asset.Colors.purple.color
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }

    // MARK: iOS 13 Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == false {
                return
            }
            let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
            if url == mapView.styleURL {
                return
            }
            guard let currentLayers = mapView.style?.layers, let viewModel = viewModel else { return }
            currentLayers.map { (layer) in
                guard let mapStyle = mapView.style else { return }
                if let styleLayer = mapStyle.layer(withIdentifier: layer.identifier) {
                     mapStyle.removeLayer(styleLayer)
                 }
            }
            viewModel.buildings.forEach { (building) in
                if let source = mapView.style?.source(withIdentifier: building.shapeSource.identifier) {
                    mapView.style?.removeSource(source)
                }
            }
            mapView.styleURL = url
        }
    }
}
