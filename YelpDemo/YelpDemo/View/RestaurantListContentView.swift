//
//  RestaurantListContentView.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantListContentView: View {
    @Environment(\.defaultStyle) private var style
    private let image: String?
    private let name: Text
    private let details: Text?
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                WebImage(url: URL(string: image ?? ""), options: .retryFailed, context: nil)
                    .placeholder(content: {
                        Image(systemName: "photo")
                            .foregroundColor(.secondary)
                    })
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
                HStack {
                    VStack(alignment: .leading, spacing: 5.0, content: {
                        name
                            .font(.headline)
                            .foregroundColor(Color(style.color.white))
                        details
                            .font(.footnote)
                            .foregroundColor(Color(style.color.white))
                    }).padding([.horizontal])
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(style.color.white))
                        .padding()
                }.background(Color.black.opacity(0.70))
                
            }
            
        }
    }
    
    init(imageUrl: String?, name: Text, details: Text?) {
        self.image = imageUrl
        self.name = name
        self.details = details
    }
}

#if DEBUG
struct RestaurantListContentView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListContentView(imageUrl: "https://s3-media1.fl.yelpcdn.com/bphoto/7J-J0-vIE-kgtF7_g9_2-w/o.jpg", name: Text("Yellowcab"), details: Text("4.3 • 5.68 miles"))
    }
}
#endif
