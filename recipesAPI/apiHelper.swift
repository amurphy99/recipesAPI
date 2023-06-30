//
//  apiHelper.swift
//  recipe_api
//
//  Created by Andrew Murphy on 6/29/23.
//

// API
// https://www.freecodecamp.org/news/how-to-make-your-first-api-call-in-swift/

// JSON
// https://developer.apple.com/documentation/foundation/jsondecoder

// Image Styling
// https://www.simpleswiftguide.com/swiftui-image-tutorial/

// Grids
// https://blog.logrocket.com/understanding-the-swiftui-grid-layout/



import Foundation
import SwiftUI



struct APImealList: Codable {
    var meals: [APImeal]?
}
struct APImeal: Codable, Hashable {
    var strMeal: String
    var strMealThumb: URL
    var idMeal: String
    
    init(strMeal: String, strMealThumb: String, idMeal: String) {
        self.strMeal = strMeal
        self.strMealThumb = URL(string: strMealThumb)!
        self.idMeal = idMeal
    }
}


struct APIdetailResults: Codable {
    var meals: [APImealDetails]?
}
// yikes
struct APImealDetails: Codable, Hashable {
    
    var idMeal: String
    var strMeal: String
    var strDrinkAlternate: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String
    var strMealThumb: String // https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg,
    var strTags: String? // null,
    var strYoutube: String? // https://www.youtube.com/watch?v=6R8ffRRJcrg,
    
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    
    var strMeasure1: String? // 200ml,
    var strMeasure2: String? // 60ml,
    var strMeasure3: String? // 2,
    var strMeasure4: String? // 1600g,
    var strMeasure5: String? // 3 tsp,
    var strMeasure6: String? // 1/2 tsp,
    var strMeasure7: String? // 25g,
    var strMeasure8: String? // 45g,
    var strMeasure9: String? // 3 tbs,
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    
    var strSource: String? // https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ,
    var strImageSource: String? // null,
    var strCreativeCommonsConfirmed: String? // null,
    var dateModified: String? // null
    
    
    // function for getting an easy to work with list of ingredients & measurements
    func getIngredients() -> [(Int, String, String)] {
        
        let ingredientsList: [String?] = [
            self.strIngredient1,
            self.strIngredient2,
            self.strIngredient3,
            self.strIngredient4,
            self.strIngredient5,
            self.strIngredient6,
            self.strIngredient7,
            self.strIngredient8,
            self.strIngredient9,
            self.strIngredient10,
            self.strIngredient11,
            self.strIngredient12,
            self.strIngredient13,
            self.strIngredient14,
            self.strIngredient15,
            self.strIngredient16,
            self.strIngredient17,
            self.strIngredient18,
            self.strIngredient19,
            self.strIngredient20
        ]
        
        let measurementsList: [String?] = [
            self.strMeasure1,  // 200ml,
            self.strMeasure2,  // 60ml,
            self.strMeasure3,  // 2,
            self.strMeasure4,  // 1600g,
            self.strMeasure5,  // 3 tsp,
            self.strMeasure6,  // 1/2 tsp,
            self.strMeasure7,  // 25g,
            self.strMeasure8,  // 45g,
            self.strMeasure9,  // 3 tbs,
            self.strMeasure10,
            self.strMeasure11,
            self.strMeasure12,
            self.strMeasure13,
            self.strMeasure14,
            self.strMeasure15,
            self.strMeasure16,
            self.strMeasure17,
            self.strMeasure18,
            self.strMeasure19,
            self.strMeasure20
        ]
        
        // return the two of them together excluding any empty values
        var finalList: [(Int, String, String)] = []
        for i in (0..<20) {
            if ingredientsList[i] != nil && ingredientsList[i] != "" {
                finalList.append((i, ingredientsList[i]!, measurementsList[i] ?? ""))
            }
        }
        return finalList
    }
}




class NetworkManager {

    // dessert list
    func fetchDesserts(completionHandler: @escaping ([APImeal]) -> Void) {
        let url: URL = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            // error handling
            if let error = error { print("Error accessing API: \(error)"); return }
            
            // confirm response status
            guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(response!)")
              return
            }
            
            // data handling
            if let data = data,
                    let APIresults = try? JSONDecoder().decode(APImealList.self, from: data) {
                    completionHandler(APIresults.meals ?? [])
                  }
        })
        task.resume()
    }
    
    // meal details from id
    func fetchMealDetails(mealID: String, completionHandler: @escaping ([APImealDetails]) -> Void) {
        let url: URL = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            // error handling
            if let error = error { print("Error accessing API: \(error)"); return }
            
            // confirm response status
            guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(response!)")
              return
            }
            
            // data handling
            if let data = data,
                    let APIresults = try? JSONDecoder().decode(APIdetailResults.self, from: data) {
                    //print("success")
                    completionHandler(APIresults.meals ?? [])
                  }
        })
        task.resume()
    }

}











