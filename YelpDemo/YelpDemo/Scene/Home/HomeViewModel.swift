//
//  HomeViewModel.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import YelpAPI
import Combine
import CoreLocation
import Stinsen

enum HomeSearchSettings: String, Equatable, CaseIterable {
    case byName = "Business Name"
    case byLocation = "Location"
    case byCategory = "Category"
}

enum HomeSortSettings: String, Equatable, CaseIterable {
    case distance = "Distance"
    case rating = "Ratings"
}

protocol HomeViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var businesses: [GPBusiness] { get }
    var searchText: String { get set }
    var selectedSearchType: HomeSearchSettings { get set }
    var selectedSortType: HomeSortSettings { get set }
    var currentCoordinate: CLLocationCoordinate2D? { get }
    var router: NavigationRouter<HomeCoordinator.Route>? { get set }
    
    func formatDistance(distance: Double?) -> String
    func fetch()
    func showBusinessDetail(_ business: GPBusiness)
    func requestLocationPermission()
}
class HomeViewModelImp: HomeViewModel {
    
    // MARK: - Inputs
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedSearchType: HomeSearchSettings = .byName
    @Published var selectedSortType: HomeSortSettings = .distance
    var router: NavigationRouter<HomeCoordinator.Route>?
    
    // MARK: - Data
    @Published var businesses: [GPBusiness] = [GPBusiness]()
    var currentCoordinate: CLLocationCoordinate2D?
    private var sortValue: String {
        get {
            switch selectedSortType {
            case .distance:
                return "distance"
            case .rating:
                return "rating"
            }
        }
    }
    
    // MARK: - Utilities
    var cancelBag = Set<AnyCancellable>()
    private var measurementFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitStyle = .long
        return formatter
    }()
    private let locationService: GPLocationService
    
    init() {
        locationService = GPLocationService()
        currentCoordinate = locationService.currentUserLocation
        setupLocationService()
        setupPublishers()
    }
    
    func setupPublishers() {
        $selectedSortType
            .sink { [weak self] sortSettings in
                self?.sortBy(setting: sortSettings)
            }.store(in: &cancelBag)
    }
    
    func formatDistance(distance: Double?) -> String {
        var distanceInMeters = Measurement(value: distance ?? 0, unit: UnitLength.meters)
        distanceInMeters.convert(to: .miles)
        return measurementFormatter.string(from: distanceInMeters)
    }
    
    func fetch() {
        switch selectedSearchType {
        case .byName:
            fetchBusiness(forTerm: searchText)
        case .byLocation:
            fetchBusiness(forLocation: searchText)
        case .byCategory:
            fetchBusiness(forCategory: searchText)
        }
    }
    
    private func sortBy(setting: HomeSortSettings) {
        switch setting {
        case .distance:
            businesses
                .sort { $0.distance ?? 0 < $1.distance ?? 0 }
        case .rating:
            businesses
                .sort { $0.rating ?? 0 > $1.rating ?? 0 }
        }
    }
    
    private func fetchBusiness(forLatitude lat: Double,andLongitude long: Double) {
        isLoading = true
        GPSearchService.search(byLatitude: lat,
                               longitude: long,
                               withTerm: nil,
                               sortyBy: sortValue,
                               radius: nil,
                               andCategories: nil)
            .sink { [weak self] response in
                
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    guard let self = self else { return }
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                self?.businesses = response.businesses
            }.store(in: &cancelBag)

    }
    
    private func fetchBusiness(forTerm term: String) {
        isLoading = true
        GPSearchService.search(byLatitude: currentCoordinate?.latitude ?? 0,
                               longitude: currentCoordinate?.longitude ?? 0,
                               withTerm: term,
                               sortyBy: sortValue,
                               radius: nil,
                               andCategories: nil)
            .sink { [weak self] response in
                
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    guard let self = self else { return }
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                print(response.businesses)
                self?.businesses = response.businesses
            }.store(in: &cancelBag)
    }
    
    private func fetchBusiness(forLocation location: String) {
        isLoading = true
        GPSearchService.search(byLocation: location,
                               withTerm: nil,
                               sortBy: sortValue,
                               radius: nil,
                               andCategories: nil)
            .sink { [weak self] response in
                
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    guard let self = self else { return }
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                print(response.businesses)
                self?.businesses = response.businesses
            }.store(in: &cancelBag)
    }
    
    private func fetchBusiness(forCategory category: String) {
        isLoading = true
        GPSearchService.search(byLatitude: currentCoordinate?.latitude ?? 0,
                               longitude: currentCoordinate?.latitude ?? 0,
                               withTerm: nil,
                               sortyBy: sortValue,
                               radius: nil,
                               andCategories: category)
            .sink { [weak self] response in
                
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    guard let self = self else { return }
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                self?.businesses = response.businesses
            }.store(in: &cancelBag)
    }
    
    func showBusinessDetail(_ business: GPBusiness) {
        router?.route(to: .detail(business: business))
    }
    
    func requestLocationPermission() {
        locationService.checkLocationAuthorization()
    }
    
    private func setupLocationService() {
        locationService.delegate = self
    }
    
    private func mockData() -> [GPBusiness] {
        return [ GPBusiness(id: "tH_fBsQME29Kn_8IQzdqGA", name: "Café Breton", price: nil, distance: nil, rating: nil, imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/7J-J0-vIE-kgtF7_g9_2-w/o.jpg", categories: nil, coordinates: nil, url: nil, phone: nil),
                 GPBusiness(id: "xdFifYsYxicmzv-QZk4vCQ", name: "The Black Pig", price: nil, distance: nil, rating: nil, imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/sVIOE0UxNh94o8OathxpxA/o.jpg", categories: nil, coordinates: nil, url: nil, phone: nil)
        ]
    }
}

extension HomeViewModelImp: GPLocationServiceDelegate {
    func authorizationTurnedOff() {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    func didUpdateLocation(location: CLLocation) {
        currentCoordinate = location.coordinate
        if isLoading {
            return
        }
        fetchBusiness(forLatitude: location.coordinate.latitude, andLongitude: location.coordinate.longitude)
    }
    
    func didCheckAuthorizationStatus(status: CLAuthorizationStatus) {
        
    }
}

