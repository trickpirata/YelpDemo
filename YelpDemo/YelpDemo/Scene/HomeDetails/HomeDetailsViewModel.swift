//
//  HomeDetailsViewModel.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import YelpAPI
import Combine
import CoreLocation
import Stinsen
import MapKit

protocol HomeDetailsViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var businessMapRegion: MKCoordinateRegion { get set }
    var businessAnnotation: MapItem { get }
    var business: GPBusiness { get }
    var distance: String { get }
    var businessDetails: GPBusinessDetails? { get }
    func getBusinessDetail()
}

class HomeDetailsViewModelImp: HomeDetailsViewModel {
    // MARK: - Inputs
    @Published var isLoading = false
    var router: NavigationRouter<HomeCoordinator.Route>?
    
    // MARK: - Outputs
    @Published var businessDetails: GPBusinessDetails?
    @Published var businessMapRegion: MKCoordinateRegion
    var businessAnnotation: MapItem {
        get {
            guard let coordinates = businessDetails?.coordinates
            else {
                return MapItem(name: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
                
            }
            return MapItem(name: business.name ?? "", coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude ?? 0, longitude: coordinates.longitude ?? 0))
        }
    }
    
    // MARK: - Data
    let business: GPBusiness

    var distance: String {
        get {
            var distanceInMeters = Measurement(value: business.distance ?? 0, unit: UnitLength.meters)
            distanceInMeters.convert(to: .miles)
            return measurementFormatter.string(from: distanceInMeters)
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

    init(withBusiness business: GPBusiness) {
        self.business = business
        self.businessMapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)
    }
    
    func getBusinessDetail() {
        guard let id = business.id else { return }
        isLoading = true
        GPDetailsService.getBusinessDetails(forID: id)
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    guard let self = self else { return }
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                self?.businessDetails = response
                if let coordinates = response.coordinates {
                    self?.businessMapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates.latitude ?? 0, longitude: coordinates.longitude ?? 0), latitudinalMeters: 750, longitudinalMeters: 750)
                }
                
            }.store(in: &cancelBag)
    }
    
    private func mock() -> GPBusinessDetails {
        return GPBusinessDetails(id: "WavvLdfdP6g8aZTtbBQHTw",
                                 name: "Gary Danko",
                                 image_url: "https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg",
                                 is_closed: false,
                                 url: "https://www.yelp.com/biz/gary-danko-san-francisco?adjust_creative=wpr6gw4FnptTrk1CeT8POg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=wpr6gw4FnptTrk1CeT8POg",
                                 phone: "+14157492060",
                                 display_phone: "(415) 749-2060", review_count: 5296, categories: [GPCategories(alias: nil, title: "American (New)"),GPCategories(alias: nil, title: "French"),GPCategories(alias: nil, title: "Wine Bars")], coordinates: nil, rating: 4.5, location: GPLocation(address1: nil, address2: nil, address3: nil, city: nil, zip_code: nil, country: nil, state: nil, display_address: ["800 N Point St", "San Francisco, CA 94109"], cross_streets: nil), photos: nil, price: "$", hours: [GPOperatingDetails(open: [GPOperationHours(is_overnight: false, start: "1730", end: "2200", day: 0)])])
    }
}

