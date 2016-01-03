//
//  DocExample.swift
//  Tf-Idf
//
//  Created by Matteo Piombo on 03/01/16.
//  Copyright © 2016 Matteo Piombo. All rights reserved.
//

import Foundation

// Generic Doc that stores terms in an array
struct ArrayDoc<DocumentIDType: Hashable, TermType: Hashable>: TFDocumentType {
    
    let documentID: DocumentIDType
    let terms: Array<TermType>
    
    func termGenerator() -> AnyGenerator<TermType> {
        var index = terms.startIndex
        return anyGenerator {
            guard index != self.terms.endIndex else { return nil }
            let result = self.terms[index]
            index = index.successor()
            return result
        }
    }
}