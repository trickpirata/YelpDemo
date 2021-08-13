//
//  HomeCoordinator.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import YelpAPI
import SwiftUI
import Stinsen
import PartialSheet

class HomeCoordinator: NavigationCoordinatable {
    var navigationStack: NavigationStack = NavigationStack()
    let sheetManager: PartialSheetManager = PartialSheetManager()
    
    enum Route: NavigationRoute {
        case detail(business: GPBusiness)
    }

    func resolveRoute(route: Route) -> Transition {
        switch route {
        case .detail(let business):
            return .push(AnyView(HomeDetailsContentView<HomeDetailsViewModelImp>(withBusiness: business)))
        }
    }
    
    @ViewBuilder func start() -> some View {
        HomeContentView<HomeViewModelImp>()
            .environmentObject(sheetManager)
    }
}
