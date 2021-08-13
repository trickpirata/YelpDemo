//
//  HomeContentView.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import YelpUI
import SwiftUI
import ActivityIndicatorView
import Stinsen
import PartialSheet

struct HomeContentView<ViewModel>: View where ViewModel: HomeViewModel {
    @EnvironmentObject private var router: NavigationRouter<HomeCoordinator.Route>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var partialSheetManager: PartialSheetManager
    @ObservedObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                GPSearchBar(placeholder: "Search by \(viewModel.selectedSearchType.rawValue)",
                            searchText: $viewModel.searchText) {

                    } returnAction: {
                        viewModel.fetch()
                    }.padding()

                List(viewModel.businesses) { item in
                    Button(action: {
                        viewModel.showBusinessDetail(item)
                    }, label: {
                        let detail = "\(item.rating ?? 0) • \(viewModel.formatDistance(distance: item.distance))"
                        RestaurantListContentView(imageUrl: item.image_url,
                                                  name: Text(item.name ?? ""),
                                                  details: Text(detail))
                    })
                    
                }.listStyle(PlainListStyle())
            }
            
            //HUD loader
            ActivityIndicatorView(isVisible: $viewModel.isLoading,
                                  type: .default)
                .frame(width: 50.0, height: 50.0)
        }.navigationTitle("Yelp Places")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarItems(trailing:
                                Button(action: {
                                    partialSheetManager.showPartialSheet {
                                        //dismissed
                                    } content: {
                                        filterView
                                    }

                                }, label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.accentColor)
                                })
        )
        .onAppear(perform: {
            viewModel.requestLocationPermission()
            viewModel.router = router
        }).addPartialSheet()
    }
    
    private var filterView: some View {
        VStack {
            Text("Settings").font(.headline)
            VStack(spacing: 20.0) {
                VStack(spacing: 0) {
                    Text("Search By")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("Search type", selection: $viewModel.selectedSearchType) {
                        ForEach(HomeSearchSettings.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(spacing: 0) {
                    Text("Sort By")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("Sort", selection: $viewModel.selectedSortType) {
                        ForEach(HomeSortSettings.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }.padding()
        }
    }
}

extension HomeContentView {
    init() {
        self.viewModel = HomeViewModelImp() as! ViewModel
    }
}

#if DEBUG
struct HomeContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sheetManager: PartialSheetManager = PartialSheetManager()
        HomeContentView<HomeViewModelImp>()
            .environmentObject(sheetManager)
    }
}
#endif
