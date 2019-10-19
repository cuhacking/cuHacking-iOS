//
//  MapViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: CUViewController, UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate {
    // MARK: Instance Variables
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
    private let viewModel: MapViewModel
    private var lineLayer: MGLLineStyleLayer!
    private var fillLayer, backdropLayer: MGLFillStyleLayer!
    private var symbolLayer: MGLSymbolStyleLayer!
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.layer.cornerRadius = 10
        return tableView
    }()

    // MARK: Functions
    init(viewModel: MapViewModel) {
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

    // MARK: Setup Methods
    private func setupMap() {
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

    private func setupLevels(style: MGLStyle) {
        if style.source(withIdentifier: viewModel.shapeSource.identifier) != nil {
            return
        }

        let source = viewModel.shapeSource
        print("Identifier:\(source.identifier) VS. \(viewModel.shapeSource.identifier)")
        style.addSource(source)

        backdropLayer = MGLFillStyleLayer(identifier: "river-building-backdrop-layer", source: source)
        backdropLayer.fillColor = NSExpression(forConstantValue: UIColor.white)

        lineLayer = MGLLineStyleLayer(identifier: "river-building-line-layer", source: source)
        lineLayer.lineWidth = NSExpression(forConstantValue: 0.5)
        lineLayer.lineColor = NSExpression(forConstantValue: UIColor.black)

        fillLayer = MGLFillStyleLayer(identifier: "river-building-fill-layer", source: source)
        let defaultFill = UIColor.purpleSix
        fillLayer.fillColor = NSExpression(format: viewModel.fillFormat, UIColor.purpleOne, UIColor.purpleTwo, UIColor.purpleThree, UIColor.purpleFour, UIColor.purpleFive, UIColor.white.withAlphaComponent(0), defaultFill)

        symbolLayer = MGLSymbolStyleLayer(identifier: "river-building-symbol-layer", source: source)
        symbolLayer.iconImageName = NSExpression(format: viewModel.symbolIconFormat, "washroom", "elevator", "stairs", "")
        symbolLayer.iconScale = NSExpression(forConstantValue: 0.2)
        symbolLayer.text = NSExpression(forKeyPath: "name")
        symbolLayer.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 0, dy: 15)))
        symbolLayer.textFontSize = NSExpression(forConstantValue: 8)

        style.addLayer(backdropLayer)
        style.addLayer(fillLayer)
        style.addLayer(symbolLayer)
        style.addLayer(lineLayer)

        updateMapPredicates()
    }
    private func setupFloorPicker() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: -20), size: CGSize(width: tableViewCellWidth, height: tableViewCellHeight*Level.allCases.count))
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
        backdropLayer.predicate = viewModel.backdropPredicate
        lineLayer.predicate = viewModel.floorPredicate
        fillLayer.predicate = viewModel.floorPredicate
        symbolLayer.predicate = viewModel.floorPredicate
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
        mapView.style?.setImage(UIImage(named: "washroom")!, forName: "washroom")
        mapView.style?.setImage(UIImage(named: "elevator")!, forName: "elevator")
        mapView.style?.setImage(UIImage(named: "stairs")!, forName: "stairs")
    }

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        print("Problem")

        setupLevels(style: style)
    }

    // MARK: TableViewDelegate & TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Level.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableViewCellHeight)
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

    // MARK: iOS 13 Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
          //  print("Okay: \(mapView.styleURL)")

            if previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection) == false {
                return
            }
            let url = traitCollection.userInterfaceStyle == .light ? MGLStyle.lightStyleURL :  MGLStyle.darkStyleURL
          //  print("Okay3: \(url)")
            if url == mapView.styleURL {
                return
            }
          //  print("here")
            mapView.styleURL = url
        }
    }
}
