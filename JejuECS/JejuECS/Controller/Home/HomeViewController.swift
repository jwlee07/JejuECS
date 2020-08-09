//
//  HomeViewController.swift
//  JejuECS
//
//  Created by 윤병일 on 2020/08/07.
//  Copyright © 2020 jwlee. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class HomeViewController : UIViewController {
  //MARK: - Properties
  
  private let mapView = MKMapView()
  private let jejuPlace = MKPointAnnotation()
  private var searchController = UISearchController(searchResultsController: nil)
  private var resetMyPlaceButton : FloatingButton = {
   let bt = FloatingButton()
    bt.setImage(UIImage(systemName: "location.circle"), for: .normal)
    return bt
  }()
  
  private var categoryButton : FloatingButton = {
    let bt = FloatingButton()
    bt.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    return bt
  }()
  
  //MARK: - viewDidLoad()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setNavi()
    setUI()
    setConstraint()
    setJejuPlace()
  }
  
  override func viewDidLayoutSubviews() {
    setButton()
  }
  
  //MARK: - setNavi()
  
  private func setNavi() {
    
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "검색"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  //MARK: - setUI()
  
  private func setUI() {
    view.addSubview(mapView)
  }
  //MARK: - setConstraint()
  
  private func setConstraint() {
    mapView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  private func setButton() {
    view.addSubview(resetMyPlaceButton)
    view.addSubview(categoryButton)
    
    resetMyPlaceButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-120)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.height.equalTo(40)
    }
    categoryButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().offset(-180)
      $0.trailing.equalToSuperview().offset(-20)
      $0.width.height.equalTo(40)
    }
  }
  //MARK: - setJejuPlace()
  
  private func setJejuPlace() {
    jejuPlace.coordinate = CLLocationCoordinate2D(latitude: 33.2721, longitude: 126.3221)
    let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
    let region = MKCoordinateRegion(center : jejuPlace.coordinate, span: span)
    mapView.setRegion(region, animated: true)
  }
}
