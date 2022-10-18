//
//  GIFTests.swift
//  GifferTests
//
//  Created by Igor Deviatko on 18.10.2022.
//

import XCTest
@testable import Giffer

class GIFTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDecoding() {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "GIF", withExtension: "json") else {
            XCTFail("Unable to load sample JSON")
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let gif = try decoder.decode(GIF.self, from: data)
            
            XCTAssertEqual(gif.media?.count, 2)
            XCTAssertEqual(gif.url?.absoluteString, "https://tenor.com/HViv.gif")
            XCTAssertEqual(gif.title, "")
            XCTAssertEqual(gif.id, "8046009")
        } catch {
            XCTFail("Error in parsing/decoding JSON")
        }
    }
}
