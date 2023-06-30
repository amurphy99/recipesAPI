//
//  DessertTests.swift
//  recipesAPITests
//
//  Created by Andrew Murphy on 6/30/23.
//

import XCTest
@testable import recipesAPI


final class DessertTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    // My tests
    // ===================================================
    
    func testFetchDesserts() {
        
        // check that the results loaded
        let expectation = XCTestExpectation(description: "Get desserts list from API.")
        var dessertResults: [APImeal] = []
        NetworkManager().fetchDesserts { (desserts) in
            XCTAssertNotNil(desserts, "Expected to load API results.")
            dessertResults = desserts
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
        
        // check that they each have an id and name
        let dataExpection = XCTestExpectation(description: "Check that each dessert has at least a non-nil name and id.")
        for dessert in dessertResults {
            XCTAssertNotNil(dessert.strMeal, "Expected to have a non-nil name.")
            XCTAssertNotNil(dessert.idMeal,  "Expected to have a non-nil id.")
        }
        dataExpection.fulfill()
        
        wait(for: [dataExpection], timeout: 10.0)
        
    }
    
    
    func testFetchDessertDetails() {
        // check all of the details load for EACH possible dessert
        let allDesertsExpectation = XCTestExpectation(description: "All desserts have valid details.")
        
        var dessertResults: [APImeal] = []
        NetworkManager().fetchDesserts { (desserts) in
            dessertResults = desserts //Array(desserts[0...3])
            
            for dessert in dessertResults {
                // check that the results load
                let expectation = XCTestExpectation(description: "Get dessert details from API.")
                self.checkDetails(mealID: dessert.idMeal)
                expectation.fulfill()
                self.wait(for: [expectation], timeout: 10.0)
            }
            
            allDesertsExpectation.fulfill()
        }
        
        wait(for: [allDesertsExpectation], timeout: 120.0)
    }
    
    func checkDetails(mealID: String) {
        var mealDetails: APImealDetails?
        NetworkManager().fetchMealDetails(mealID: mealID) { (results) in
            XCTAssertNotNil(results,    "Expected to meal details.")
            XCTAssertNotNil(results[0], "Expected that there would be a APImealDetails object.")
            mealDetails = results[0]
            
            // check that the instructions and ingredients/measurements are valid
            XCTAssertNotNil(mealDetails?.strInstructions, "Expected to have non-nil instructions.")
            
            let ingredientsList: [(Int, String, String)] = mealDetails!.getIngredients()
            XCTAssertNotNil(ingredientsList, "Expected to get ingredients list.")
            
            for i in 0..<ingredientsList.count {
                XCTAssertNotNil(ingredientsList[i].1,  "Expected to have a non-nil ingredient name.")
                XCTAssertNotNil(ingredientsList[i].2,  "Expected to have a non-nil measurement.")
            }
        }
    }
    

}
