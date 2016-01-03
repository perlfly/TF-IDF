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
    
    /// Adds document info to the corpus
    /// Stores document ID, its term frequencies and updates the corpus terms frequencies
    ///
    /// - Parameter document: the document to be added
    ///
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
    
    
    /// Removes a document from the corpus
    ///
    /// Updates corpus terms statistics and removes the document's terms frequency
    /// - Parameter document: The document to be removed
    func removeDocument(document: D) {
        guard let tf = documentsTF[document.documentID] else { return } // return immediatelly in case the document was not added
        
        // update corpus terms count
        for term in tf.keys {
            guard let corpusCount = corpusTermCount[term] else { return }
            
            corpusTermCount[term] = (corpusCount > 1) ? corpusCount - 1 : nil

        }
        
        // Remove document's terms frequency
        documentsTF[document.documentID] = nil
    }
    
    /// Calculates TF-IDF score for each document containing the given term at least one time
    ///
    /// - Parameter term: the term to be used for scoreing
    ///
    /// - Returns: Array of tuple (docID, score) where _docID_ is the doc identifier and _score_
    ///     is the doc's score for the given _term_
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



