import XCTest
import class Foundation.Bundle
import SwiftSyntax
@testable import AbsoluteHSBKit

final class AbsoluteHSBTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("AbsoluteHSB")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

//    func testRewrite() throws {
//
//        let answerString = """
////
////  ContentSample.swift
////  AbsoluteHSB
////
////  Created by 藤井陽介 on 2019/03/23.
////
//
//import UIKit
//
//let color1 = UIColor(hue: 1.0, saturation: 0.31372549, brightness: 0.392156863, alpha: 1.0) // h 1.0, s 0.31372549, b .392156863
//let color2 = UIColor.init(hue: 0.083333333, saturation: 0.156862745, brightness: 0.192156863, alpha: 0.4)
//"""
//        if #available(OSX 10.11, *) {
//            let sourceFile = try SyntaxTreeParser.parse(URL, relativeTo: nil)!)
//            let syntax = ColorSyntaxRewriter().visit(sourceFile)
//
//            XCTFail(syntax.description)
//            XCTAssertEqual(syntax.description, answerString)
//        } else {
//            // Fallback on earlier versions
//        }
//    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
