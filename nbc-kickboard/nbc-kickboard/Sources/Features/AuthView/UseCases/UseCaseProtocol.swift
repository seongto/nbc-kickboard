//
//  UseCaseProtocol.swift
//  nbc-kickboard
//
//

import Foundation

protocol UseCaseProtocol {
    associatedtype Input
    associatedtype Output
    
    func execute(_ input: Input) -> Output
}
