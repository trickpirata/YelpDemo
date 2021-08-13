//
//  MainCoordinator.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import Foundation
import SwiftUI
import Stinsen

class MainCoordinator: ViewCoordinatable {
    var children = ViewChild()
    
    enum Route: ViewRoute {
        case home
    }

    func resolveRoute(route: Route) -> AnyCoordinatable {
        switch route {
        case .home:
            return AnyCoordinatable(
                NavigationViewCoordinatable(HomeCoordinator())
            )
        }
    }
    
    @ViewBuilder func start() -> some View {
        SplashContentView()
    }
}
