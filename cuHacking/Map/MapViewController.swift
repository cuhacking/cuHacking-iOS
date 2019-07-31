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
    private var cardViewController : CardViewController!
    private var visualEffectView : UIVisualEffectView!
    private let CARD_HEIGHT : CGFloat = 350
    private var cardVisible = false
    private var cardNextStae : CardState {
        return cardVisible ? .expanded : .collapsed
    }
    private var runningCardAnimations = [UIViewPropertyAnimator]()
    private var cardAnimationProgressWhenInterrupted : CGFloat = 0
    private var levels = [MGLLineStyleLayer]()
    private var mapView : MGLMapView!
    private let TABLE_VIEW_CELL_WIDTH = 50
    private let TABLE_VIEW_CELL_HEIGHT = 50
    private let viewModel : MapViewModel
    private var lineLayer : MGLLineStyleLayer!
    private var symbolLayer, roomLabelLayer, washroomSymbolLayer, stairsSymbolLayer, elevatorSymbolLayer  : MGLSymbolStyleLayer!
    private var fillLayer, roomFill, washroomFill, elevatorFill, hallwayFill, stairsFill, nullFill : MGLFillStyleLayer!
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
        setupCard()
    }
    
    //MARK: Setup Methods
    private func setupMap(){
        let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 45.3823547, longitude: -75.6974599), zoomLevel: 18, animated: false)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(roomTapped(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        view.addSubview(mapView)
    }
    
    private func setupLevels(){
        let source = viewModel.shapeSource
        mapView.style?.addSource(source)

        lineLayer = MGLLineStyleLayer(identifier: "river-building-line-layer", source:source)
        lineLayer.lineWidth = NSExpression(forConstantValue: 0.5)
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.black)

        fillLayer = MGLFillStyleLayer(identifier: "river-building-fill-layer", source: source)
        let defaultFill = UIColor.purpleSix
        fillLayer.fillColor = NSExpression(format: viewModel.fillFormat, UIColor.purpleOne, UIColor.purpleTwo, UIColor.purpleThree, UIColor.purpleFour, UIColor.purpleFive, defaultFill)
      
        
        symbolLayer = MGLSymbolStyleLayer(identifier: "river-building-symbol-layer", source: source)
        symbolLayer.iconImageName = NSExpression(format: viewModel.symbolIconFormat, "washroom","elevator","stairs","")
        symbolLayer.iconScale = NSExpression(forConstantValue: 0.1)
       
        mapView.style?.addLayer(fillLayer)
        mapView.style?.addLayer(symbolLayer)
        mapView.style?.addLayer(lineLayer)
        
        updateMapPredicates()
    }

//    private func setupLevels(){
//        let source = viewModel.shapeSource
//
//        floorOutline = MGLLineStyleLayer(identifier: "floor1", source:source)
//        floorOutline.lineWidth = NSExpression(forConstantValue: 0.5)
//        floorOutline.lineColor = NSExpression(forConstantValue: UIColor.brown)
//
//        roomFill = MGLFillStyleLayer(identifier: "roomFill", source: source)
//        roomFill.fillColor = NSExpression(forConstantValue: UIColor.blue)
//
//        washroomFill = MGLFillStyleLayer(identifier: "washroomFill", source: source)
//        washroomFill.fillColor = NSExpression(forConstantValue: UIColor.orange)
//
//        elevatorFill = MGLFillStyleLayer(identifier: "elevatorFill", source: source)
//        elevatorFill.fillColor = NSExpression(forConstantValue: UIColor.purple)
//
//        hallwayFill = MGLFillStyleLayer(identifier: "hallwayFill", source: source)
//        hallwayFill.fillColor = NSExpression(forConstantValue: UIColor.red)
//
//        stairsFill = MGLFillStyleLayer(identifier: "stairsFill", source: source)
//        stairsFill.fillColor = NSExpression(forConstantValue: UIColor.yellow)
//
//        nullFill = MGLFillStyleLayer(identifier: "nullFill", source: source)
//        nullFill.fillColor = NSExpression(forConstantValue: UIColor.white)
//
//        roomLabelLayer = MGLSymbolStyleLayer(identifier: "roomLabelLayer", source: source)
//        roomLabelLayer.textFontSize = NSExpression(forConstantValue: 10)
//        roomLabelLayer.text = NSExpression(forKeyPath: "room")
//
//        washroomSymbolLayer = MGLSymbolStyleLayer(identifier: "washroomSymbolLayer", source: source)
//        washroomSymbolLayer.iconImageName = NSExpression(forConstantValue: "washroom")
//        washroomSymbolLayer.iconScale = NSExpression(forConstantValue: 0.1)
//        washroomSymbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 10)))
//        washroomSymbolLayer.text = NSExpression(forKeyPath: "room")
//        washroomSymbolLayer.textFontSize = NSExpression(forConstantValue: 8)
//
//        elevatorSymbolLayer = MGLSymbolStyleLayer(identifier: "elevatorSymbolLayer", source: source)
//        elevatorSymbolLayer.iconImageName = NSExpression(forConstantValue: "elevator")
//        elevatorSymbolLayer.iconScale = NSExpression(forConstantValue: 0.15)
//
//        stairsSymbolLayer = MGLSymbolStyleLayer(identifier: "stairsSymbolLayer", source: source)
//        stairsSymbolLayer.iconImageName = NSExpression(forConstantValue: "stairs")
//        stairsSymbolLayer.iconScale = NSExpression(forConstantValue: 0.1)
//        stairsSymbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 10)))
//        stairsSymbolLayer.text = NSExpression(forKeyPath: "room")
//        stairsSymbolLayer.textFontSize = NSExpression(forConstantValue: 8)
//
//        updateMapPredicates()
//
//        mapView.style?.addSource(source)
//        mapView.style?.addLayer(nullFill)
//        mapView.style?.addLayer(roomFill)
//        mapView.style?.addLayer(elevatorFill)
//        mapView.style?.addLayer(hallwayFill)
//        mapView.style?.addLayer(stairsFill)
//        mapView.style?.addLayer(washroomFill)
//        mapView.style?.addLayer(floorOutline)
//        mapView.style?.addLayer(roomLabelLayer)
//        mapView.style?.addLayer(washroomSymbolLayer)
//        mapView.style?.addLayer(elevatorSymbolLayer)
//        mapView.style?.addLayer(stairsSymbolLayer)
//    }
    
    private func setupFloorPicker(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: TABLE_VIEW_CELL_WIDTH, height: TABLE_VIEW_CELL_HEIGHT*Level.allCases.count))
    }
    
    private func setupCard() {
//        visualEffectView = UIVisualEffectView(frame: self.view.frame)
//        self.view.addSubview(visualEffectView)
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: CARD_HEIGHT)
        cardViewController.view.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleTap))
        cardViewController.view.addGestureRecognizer(tapGesture)
        self.view.addSubview(cardViewController.view)

    }
    func hideCard(){
        let frameAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.cardViewController.view.frame.origin.y = self.view.frame.height
        }
        frameAnimator.startAnimation()
    }
    func showCard(){
        let frameAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
            self.cardViewController.view.frame.origin.y = self.view.bounds.height-self.CARD_HEIGHT
        }
        frameAnimator.startAnimation()
    }
    @objc func handleTap(){
        hideCard()
    }
    
    @objc func handleCardPan(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        self.cardViewController.view.center.y += translation.y
//        switch recognizer.state{
//        case .began:
//            //Start animation
//          //  startInteractiveTransition(state: cardNextStae, duration: 0.9)
//
//        case .changed:
//            //updateTransition
//            let translation = recognizer.translation(in: self.cardViewController.view)
//            var fractionCompleted = translation.y
//            print("completed:\(fractionCompleted)")
//            fractionCompleted = cardVisible ? fractionCompleted : -fractionCompleted
//            updateInteractiveTransition(fractionCompleted: fractionCompleted)
//        case .ended:
//            //Continue transition
//            continueInteractiveTransition()
//        default:
//            break
//        }
    }
    
    private func animateCardTransitionIfNeeded(state: CardState, duration: TimeInterval){
        if runningCardAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.CARD_HEIGHT
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
    private func startInteractiveTransition(state: CardState, duration: TimeInterval){
        if runningCardAnimations.isEmpty {
            //run animations
            animateCardTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningCardAnimations {
            animator.pauseAnimation() //sets speed to 0 (making it interactive)
            cardAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    private func updateInteractiveTransition(fractionCompleted: CGFloat){
        for animator in runningCardAnimations {
            animator.fractionComplete = fractionCompleted
        }
    }
    private func continueInteractiveTransition(){
        for animator in runningCardAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    private func updateMapPredicates(){
        lineLayer.predicate = viewModel.floorPredicate
        fillLayer.predicate = viewModel.floorPredicate
        symbolLayer.predicate = viewModel.floorPredicate
    }
//    private func updateMapPredicates(){
//        floorOutline.predicate = viewModel.linePredicate
//        roomLabelLayer.predicate = viewModel.roomLabelPredicate
//        roomFill.predicate = viewModel.roomFill
//        washroomFill.predicate = viewModel.washroomFill
//        elevatorFill.predicate = viewModel.elevatorFill
//        stairsFill.predicate = viewModel.stairsFill
//        hallwayFill.predicate = viewModel.hallwayFill
//        nullFill.predicate = viewModel.nullFill
//        washroomSymbolLayer.predicate = viewModel.washroomSymbolPredicate
//        elevatorSymbolLayer.predicate = viewModel.elevatorSymbolPredicate
//        stairsSymbolLayer.predicate = viewModel.stairsSymbolPredicate
//    }
    
    @objc func roomTapped(sender: UITapGestureRecognizer){
        let spot = sender.location(in: mapView)
        if let room = mapView.visibleFeatures(at: spot).last {
            print(room)
            cardViewController.titleLabel.text = room.attributes["room"] as? String ?? ""
            showCard()
        }
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
