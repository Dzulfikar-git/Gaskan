//
//  DispatchQueue.swift
//  Gaskan
//
//  Created by Dzulfikar on 20/08/23.
//

import Foundation
public extension DispatchQueue {

    private static let isRunningUnitTests: Bool = {
        Thread.current.threadDictionary.allKeys.contains {
            ($0 as? String)?.range(of: "XCTest", options: .caseInsensitive) != nil
        }
    }()

    func asyncTestable(
        closure: @escaping @convention(block) () -> Void
    ) {
        let workItem = DispatchWorkItem(block: closure)
        asyncTestable(execute: workItem)
    }

    func asyncTestable(
        execute workItem: DispatchWorkItem
    ) {
        if !Self.isRunningUnitTests {
            async(execute: workItem)
        } else {
            workItem.perform()
        }
    }
}
