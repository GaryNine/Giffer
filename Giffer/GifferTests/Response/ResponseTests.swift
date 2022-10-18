//
//  ResponseTest.swift
//  GifferTests
//
//  Created by Igor Deviatko on 18.10.2022.
//

import XCTest
@testable import Giffer

class ResponseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "Response", withExtension: "json") else {
            XCTFail("Unable to load sample JSON")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let response = try decoder.decode(Response.self, from: data)
            
            XCTAssertEqual(response.results?.count, 2)
            XCTAssertEqual(response.next, "7")
        } catch {
            XCTFail("Error in parsing/decoding JSON")
        }
    }
}
