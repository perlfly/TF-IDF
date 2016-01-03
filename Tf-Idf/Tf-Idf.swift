//
//  Tf-Idf.swift
//  Tf-Idf
//
//  Created by Matteo Piombo on 20/12/15.
//  Copyright © 2015 Matteo Piombo. All rights reserved.
//

import Foundation

/// Term Frequency Document Type Protocol
///
/// typealias:
protocol TFDocumentType {
    typealias DocumentIDType: Hashable
    typealias TermType: Hashable
    
    var documentID: DocumentIDType { get }

    func termGenerator() -> AnyGenerator<TermType>
}

/// TF-IDF Generic Class
///
/// Will store docuemnt IDs, documents terms freqencies and corpus term count
final class TF_IDF<D: TFDocumentType> {
    
    typealias TermCount = Dictionary<D.TermType, Int>
    
    var documentsTF: Dictionary<D.DocumentIDType, TermCount>
    var corpusTermCount: TermCount
    
    init() {
        self.documentsTF = [:]
        corpusTermCount = [:]
    }
    
    func addDocument(document: D) {
        var tf: TermCount = [:]
        let termGenerator = document.termGenerator()
        for term in termGenerator {
            if let count = tf[term] {
                tf[term] = count + 1
            } else {
                tf[term] = 1
                corpusTermCount[term] = (corpusTermCount[term] ?? 0) + 1
            }
        }
        documentsTF[document.documentID] = tf
    }
    
    func documentsForTerm(term: D.TermType) -> [(docID: D.DocumentIDType, score: Double)] {
        guard let documentsTermCount = corpusTermCount[term] else {
            return []
        }
        
        var results: Array<(docID: D.DocumentIDType, score: Double)> = []
        let idf = log(Double(documentsTF.count) / Double(documentsTermCount))
        
        for (document, documentTermCount) in documentsTF {
            if let tf = documentTermCount[term] {
                let score = Double(tf) * idf
                results.append((document, score))
            }
        }
        
        return results
    }
}



