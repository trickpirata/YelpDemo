//
//  GPStarRating.swift
//  YelpUI
//
//  Created by Trick Gorospe on 8/13/21.
//

import SwiftUI
import Cosmos

public struct GPStarRating: UIViewRepresentable {
    @Environment(\.defaultStyle) private var style
    
    private var rating: Double
    private var starSize: Double

    public func makeUIView(context: Context) -> CosmosView {
        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .precise
        cosmosView.settings.updateOnTouch = false
        cosmosView.settings.filledColor = style.color.primaryAppColor
        cosmosView.settings.emptyBorderColor = style.color.customGray
        return cosmosView
    }
    
    public func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        
        // Autoresize Cosmos view according to it intrinsic size
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // Change Cosmos view settings here
        uiView.settings.starSize = starSize
    }
    
    public init(rating: Double, starSize: Double = 40) {
        self.rating = rating
        self.starSize = starSize
    }
}

#if DEBUG
struct GPStarRating_Previews: PreviewProvider {
    static var previews: some View {
        GPStarRating(rating: 4.5)
    }
}
#endif
