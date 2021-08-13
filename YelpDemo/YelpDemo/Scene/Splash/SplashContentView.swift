//
//  SplashContentView.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/13/21.
//

import SwiftUI
import Stinsen

struct SplashContentView: View {
    @EnvironmentObject private var router: ViewRouter<MainCoordinator.Route>
    
    @State private var scale = false
    var body: some View {
        VStack {
            Spacer()
            Image("yelplogo")
                .scaleEffect(scale ? 1 : 2)
                .animation(.linear(duration: 1.5))
            Spacer()
            Text("Demo by Patrick Gorospe")
                .font(.footnote)
                .foregroundColor(.secondary)
        }.onAppear(perform: {
            scale.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                router.route(to: .home)
            }
        })
        
    }
}

#if DEBUG
struct SplashContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashContentView()
    }
}
#endif
