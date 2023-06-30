//
//  DessertView.swift
//  recipe_api
//
//  Created by Andrew Murphy on 6/29/23.
//

import SwiftUI

struct DessertCardView: View {

    let meal: APImeal
    
    var body: some View {
        VStack {
            AsyncImage(
                url: meal.strMealThumb,
                content: { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                },
                placeholder: { ZStack { Spacer(); ProgressView() } }
            )
            .cornerRadius(15)
            .shadow(radius: 5)

            Text("\(meal.strMeal)")
                .fontWeight(.light)
                .foregroundColor(Color.black)
            
            Spacer()
        }
    }
}


struct DessertCardView_Previews: PreviewProvider {
    static var previews: some View {

        let previewMeal: APImeal = APImeal(
            strMeal: "Apam balik",
            strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
            idMeal: "53049")
        
        DessertCardView(meal: previewMeal)
    }
}
