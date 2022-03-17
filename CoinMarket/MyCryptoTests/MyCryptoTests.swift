//
//  MyCryptoTests.swift
//  MyCryptoTests
//
//  Created by SREEKANTH PS on 15/03/2022.
//

import XCTest
@testable import MyCrypto

class MyCryptoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchCurrencies(){
        
        let exp = expectation(description:"fetching currenciew from server")
        
        let coinLimit = 100
        let strUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap _desc&per_page=\(coinLimit)&page=1&sparkline=false"
        if let encoded = strUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let myURL = URL(string: encoded) {
            
            let session: URLSession = URLSession(configuration: .default)
            session.dataTask(with: myURL) { data, response, error in
               XCTAssertNil(error)
               exp.fulfill()
            }.resume()
            waitForExpectations(timeout: 10.0) { (error) in
               print(error?.localizedDescription ?? "error")
            }
        }
           
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

}
