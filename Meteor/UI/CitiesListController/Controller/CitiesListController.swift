//
//  CitiesLiestController.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit
import CoreLocation

class CitiesListController: UIViewController {
    
    // MARK: UI elements 􀯱
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var restartButton: LoaderButton!
    
    var collectionPadding: CGFloat = 10
    
    // MARK: Data Management 􀤃
    typealias DataSource = UICollectionViewDiffableDataSource<Int,OWResultModel>
    var dataSource: DataSource?
    var viewModel = CitiesListControllerViewModel()
    let locationManager = CLLocationManager()
    // MARK: View life cycle 􀐰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "weather1")
        
        locationManager.delegate = self
        locationManager.requestLocation()
        
        viewModel.delegate = self
        
        makeDataSource()
        setUpCollectionView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restartButton.startLoading(duration: 60)
        loadCitiesWeatherForDefaultCities()
    }
    
    // MARK: Navigation 􀋒
    
    // MARK: Interactions 􀛹
    @IBAction func restartButtonPressed(_ sender: UIButton) {
        restartButton.startLoading(duration: 60)
        viewModel.resetResults()
        applySnapshot([])
        loadCitiesWeatherForDefaultCities()
    }
    func loadCitiesWeatherForDefaultCities() {
        var delay: TimeInterval = 10
        for i in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                if let location = self?.viewModel.defaultCities[i] {
                    self?.viewModel.loadWeather(for: location, isCurrentLocation: false)
                }
            }
            delay += 10
        }
    }
    // MARK: UI construction 􀤋
    func updateUI(for weather: OWResultModel?) {
        let color = weather?.weather.first?.getWeatherUIPack()?.color
        
        view.backgroundColor = color
        restartButton.backgroundColor = color
        
        let headerPaths: [IndexPath] = [.init(item: 0, section: 0), .init(item: 0, section: 1)]
        for path in headerPaths {
            let header = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader,
                                                          at: path)
                header?.backgroundColor = color
        }
        
        for cell in collectionView.visibleCells {
            cell.backgroundColor = color
        }
        
    }
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = collectionPadding
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.registerNib(ofType: CityWeatherCell.self)
        collectionView.registerHeaderNib(ofType: CityListHeader.self)
        collectionView.registerNib(ofType: LocalWeatherCell.self)
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 0, left: collectionPadding, bottom: 150, right: collectionPadding)
    }
    // MARK: Tracking 􀬱
    
}
extension CitiesListController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func makeDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, weather in
            if indexPath.section == 0 && collectionView.numberOfSections > 1 {
                let cell = collectionView.dqReusableCell(ofType: LocalWeatherCell.self, for: indexPath)
                cell.model = weather
                return cell
            } else {
                let cell = collectionView.dqReusableCell(ofType: CityWeatherCell.self, for: indexPath)
                cell.model = weather
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, type, indexPath -> UICollectionReusableView? in
            let header = collectionView.dqHeader(ofType: CityListHeader.self, for: indexPath)
            header.title.text = (indexPath.section == 0 && collectionView.numberOfSections > 1) ? "Ma position" : "Mes villes"
            return header
        }
    }
    func applySnapshot(_ cities: [OWResultModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int,OWResultModel>()
        
        if let currentLocation = viewModel.localWeather {
            snapshot.appendSections([0])
            snapshot.appendItems([currentLocation], toSection: 0)
        }
        
        snapshot.appendSections([1])
        snapshot.appendItems(cities, toSection: 1)
        dataSource?.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - collectionPadding*2,
                      height: (indexPath.section == 0 && collectionView.numberOfSections > 1) ? 280 : 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}
extension CitiesListController: CitiesListControllerViewModelDelegate {
    func citiesListControllerViewModel(didLoadLocalWeather weather: OWResultModel?, otherCities: [OWResultModel]) {
        updateUI(for: weather)
        applySnapshot(otherCities)
    }
    func citiesListControllerViewModel(didLoadWeather weather: [OWResultModel]) {
        (viewModel.localWeather != nil) ? () : updateUI(for: weather.first)
        applySnapshot(weather)
    }
}
extension CitiesListController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewModel.loadWeather(for: location, isCurrentLocation: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
