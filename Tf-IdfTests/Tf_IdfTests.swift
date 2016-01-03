//
//  Tf_IdfTests.swift
//  Tf-IdfTests
//
//  Created by Matteo Piombo on 20/12/15.
//  Copyright © 2015 Matteo Piombo. All rights reserved.
//

import XCTest
@testable import Tf_Idf

class Tf_IdfTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
        let foo = ArrayDoc(documentID: "foo", terms: [1, 2, 3, 4, 2, 8, 3])
        let bar = ArrayDoc(documentID: "bar", terms: [1, 4, 8, 4, 2, 8, 3, 9, 10])
        let emptyDoc = ArrayDoc(documentID: "Empty", terms: Array<Int>())
        
        let tf_idf_Ints = TF_IDF<ArrayDoc<String, Int>>()
        
        tf_idf_Ints.addDocument(foo)
        tf_idf_Ints.addDocument(bar)
        print(tf_idf_Ints.termCount)
        print(tf_idf_Ints.documentsTF[foo.documentID])
        print(tf_idf_Ints.documentsForTerm(4))
        print(tf_idf_Ints.documentsForTerm(10))
        
        // Test Empty Docs
        tf_idf_Ints.addDocument(emptyDoc)
        
        
        
        // Test with strings
        
        // Extract terms from a String splitting by " " and lowercasing
        func terms(frase: String) -> [String] {
            let splitted = frase.characters.split(isSeparator: {return $0 == " "}).map { String($0).lowercaseString }
            return splitted
        }
        
        let catFrase = "The cat is on the table"
        let dogFrase = "The dog is under the table"
        let pencilFrase = "The pencil is on the desk"
        
        let cat = ArrayDoc(documentID: catFrase, terms: terms(catFrase))
        let dog = ArrayDoc(documentID: dogFrase, terms: terms(dogFrase))
        let pencil = ArrayDoc(documentID: pencilFrase, terms: terms(pencilFrase))
        
        let tf_idf_Frases = TF_IDF<ArrayDoc<String, String>>()
        tf_idf_Frases.addDocument(cat)
        tf_idf_Frases.addDocument(dog)
        tf_idf_Frases.addDocument(pencil)
        
        print(tf_idf_Frases.documentsForTerm("the"))
        print(tf_idf_Frases.documentsForTerm("table"))
        print(tf_idf_Frases.documentsForTerm("cat"))
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
