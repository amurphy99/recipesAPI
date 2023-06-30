//
//  DessertDetailView.swift
//  recipe_api
//
//  Created by Andrew Murphy on 6/29/23.
//

import SwiftUI

struct DessertDetailView: View {
    
    var meal: APImeal
    
    @State private var details: APImealDetails?
    @State private var ingredients: [(Int, String, String)] = []

    private let listHeight: CGFloat = UIScreen.main.bounds.height*0.5
    
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                
                // Information
                // =================================================
                HStack {
                    Text("Instructions").font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal).padding(.vertical, 10)
                
                VStack {
                    Text("\(details != nil ? details!.strInstructions : "not loaded")")
                }
                .padding()
                .background(Color.white).cornerRadius(15)
                .padding(.horizontal)
                
                
                // Ingredients List
                // =================================================
                HStack {
                    Text("Ingredients").font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal).padding(.vertical, 10)
                
                List {
                    ForEach(ingredients, id: (\.0)) { ingredient in
                        Text("\(ingredient.1) \(ingredient.2)")
                    }
                }
                .cornerRadius(15)
                .padding(.horizontal)
                .frame(height: listHeight)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(
            AsyncImage(
                url: meal.strMealThumb,
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .blur(radius: 20)
                },
                placeholder: { ZStack { Spacer(); ProgressView() } }
            )
        )
        .onAppear {
            NetworkManager().fetchMealDetails(mealID: meal.idMeal) { (results) in
                self.details = results[0]
                self.ingredients = self.details!.getIngredients()
            }
        }
    }
}



struct DessertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let previewMeal: APImeal = APImeal(
            strMeal: "Apam balik",
            strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
            idMeal: "53049"
        )
        
        DessertDetailView(meal: previewMeal)
    }
}
