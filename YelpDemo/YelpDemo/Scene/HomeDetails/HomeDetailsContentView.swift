//
//  HomeDetailsContentView.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import SwiftUI
import YelpAPI
import YelpUI
import Stinsen
import SDWebImageSwiftUI
import ActivityIndicatorView
import MapKit

struct HomeDetailsContentView<ViewModel>: View where ViewModel: HomeDetailsViewModel  {
    @Environment(\.defaultStyle) private var style
    @EnvironmentObject private var router: NavigationRouter<HomeCoordinator.Route>
    @ObservedObject private var viewModel: ViewModel
    
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack {
                        //Header
                        ZStack(alignment: .bottom) {
                            WebImage(url: URL(string: viewModel.businessDetails?.image_url ?? ""), options: .retryFailed, context: nil)
                                .placeholder(content: {
                                    Image(systemName: "photo")
                                        .foregroundColor(.secondary)
                                })
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width , height: geometry.size.height * 0.40, alignment: .center)
                                .clipped()
                            
                            restaurantName
                        }
                        
                        //star and reviews
                        HStack {
                            GPStarRating(rating: viewModel.businessDetails?.rating ?? 1.0,
                                         starSize: 25)
                            Text("\(viewModel.businessDetails?.review_count ?? 0) Reviews")
                                .font(.caption)
                            Spacer()
                        }.padding([.leading])
                        
                        //price and distance
                        HStack {
                            HStack(spacing: 0) {
                                let totalPrice = 4
                                let businessPrice = viewModel.businessDetails?.price?.count ?? 0
                                ForEach(0..<businessPrice, id: \.self) { count in
                                    if let price = viewModel.businessDetails?.price,
                                       let priceFirst = price.first,
                                       let priceString = String(priceFirst) {
                                        Text(priceString)
                                            .font(.body)
                                            .foregroundColor(Color(style.color.primaryAppColor))
                                    }
                                }
                                ForEach(0..<(totalPrice - businessPrice), id: \.self) { count in
                                    if let price = viewModel.businessDetails?.price,
                                       let priceFirst = price.first,
                                       let priceString = String(priceFirst) {
                                        Text(priceString)
                                            .font(.body)
                                            .foregroundColor(Color(style.color.customGray))
                                    }
                                }
                            }
                            Text("• \(viewModel.distance)")
                                .font(.body)
                            Spacer()
                        }.padding([.leading])
                        
                        //Category
                        HStack {
                            let categories = viewModel.businessDetails?.categories?
                                .compactMap { $0.title }
                                .joined(separator: ", ")
                            Text(categories ?? "")
                                .font(.body)
                            Spacer()
                        }.padding([.leading])
                        
                        Spacer()
                        
                        VStack {
                            Map(coordinateRegion: $viewModel.businessMapRegion,
                                interactionModes: [],
                                showsUserLocation: false,
                                annotationItems: [viewModel.businessAnnotation]) { item in
                                    MapMarker(coordinate: item.coordinate, tint: Color(style.color.primaryAppColor))
                                }.frame(height: geometry.size.height * 0.39, alignment: .center)
                            let address = viewModel.businessDetails?
                                .location?
                                .display_address?
                                .compactMap { $0 }
                                .joined(separator: ", ")
                                
                            Text(address ?? "")
                                .font(.callout)
                                .fontWeight(.medium)
                        }

                        Spacer()
                    }
                }
                //HUD loader
                ActivityIndicatorView(isVisible: $viewModel.isLoading,
                                      type: .default)
                    .frame(width: 50.0, height: 50.0)
            }
        }.onAppear(perform: {
            viewModel.getBusinessDetail()
        }).navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private var restaurantName: some View {
        HStack(alignment: .center) {
            Text(viewModel.businessDetails?.name ?? "")
                .lineLimit(nil)
                .font(.title2)
                .foregroundColor(.white)
            
        }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
        .background(Color.black.opacity(0.70))
    }
}

extension HomeDetailsContentView {
    init(withBusiness business: GPBusiness) {
        self.viewModel = HomeDetailsViewModelImp(withBusiness: business) as! ViewModel
    }
}

#if DEBUG
struct HomeDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        let business = GPBusiness(id: "tH_fBsQME29Kn_8IQzdqGA", name: "Café Breton", price: "$$$", distance: 1041.5644579112407, rating: 0, imageUrl: "https://s3-media2.fl.yelpcdn.com/bphoto/qKglYDZFHj_l-e-65BP96w/o.jpg", categories: nil, coordinates: nil, url: nil, phone: nil)
        NavigationView {
            HomeDetailsContentView<HomeDetailsViewModelImp>(withBusiness: business)
        }
        
    }
}
#endif
