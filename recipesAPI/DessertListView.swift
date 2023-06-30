//
//  DessertListView.swift
//  recipe_api
//
//  Created by Andrew Murphy on 6/29/23.
//

import SwiftUI

struct DessertListView: View {
        
    @State private var desserts: [APImeal] = []
    
    // For View formatting
    private let items: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    // For Previews
    private let preview_mode: Bool = false // change to false when previewing using the actual api
    private let sample_size: Int = 9
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: items, alignment: .leading, spacing: 10) {
                    ForEach(desserts, id: \.self) { dessert in
                        NavigationLink {
                            DessertDetailView(meal: dessert)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .principal) {
                                        VStack {
                                            Text("\(dessert.strMeal)")
                                                .font(.title3).bold()
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                }
                        } label: { DessertCardView(meal: dessert).padding(.horizontal, 5) }
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 10)
            }
            .navigationTitle("Desserts")
            
        } // end NavigationView
        .onAppear{
            // Retrieve API data
            // don't spam API calls and take forever to load while working
            if preview_mode {
                self.desserts = Array(NetworkManager().fetchDesserts_previews()[0...(sample_size-1)]).sorted(by: { $0.strMeal < $1.strMeal })
            }
            else {
                NetworkManager().fetchDesserts { (desserts) in self.desserts = desserts.sorted(by: { $0.strMeal < $1.strMeal }) }
            }
            
            // navbar
            let appearance = UINavigationBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
