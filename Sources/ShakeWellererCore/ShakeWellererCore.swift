//
//  ShakeWellererCore.swift
//  ShakeWellererCore
//

import Foundation
import Cocoa

public final class ShakeWellererCore {
    private let arguments: [String]

    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
    }

    public func run() throws {
        var rawSnippets: String? = nil
        var extraLines: Int? = nil

        if let selector = ProcessInfo.processInfo.environment["Selector"] {
            rawSnippets = ProcessInfo.processInfo.environment[selector]
            if let extraLinesSelector = ProcessInfo.processInfo.environment["ExtraLines"],
            let extraLinesString = ProcessInfo.processInfo.environment[extraLinesSelector] {
                extraLines = Int(extraLinesString)
            }
        } else if arguments.count > 2 {
            extraLines = Int(arguments[1])
            if let data = Data(base64Encoded: arguments[2]) {
                rawSnippets = String(data: data, encoding: .utf8)
            }
        }

        guard let snippetsString = rawSnippets,
            let extraLines = extraLines else {
            print("Failed to get snippets or extra lines.")
            exit(1)
        }

        let snippets = snippetsString.split(separator: "--").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }

        shakeWell(snippetArray: snippets, extraLines: extraLines)
    }

    func shakeWell(snippetArray: [String], extraLines: Int) {

        // Get the current clipboard contents and store it
        var clipboardData: [String: Data] = [:]
        if let clipboardTypes = NSPasteboard.general.types {
            for type in clipboardTypes {
                clipboardData[type.rawValue] = NSPasteboard.general.data(forType: type)
            }
        }

        // Select a random string from the array.
        var snippet: String = ""
        if let randomElement = snippetArray.randomElement() {
            snippet = randomElement
        } else {
            print("snippetArray is empty.")
            exit(1)
        }

        // add the specified number of line breaks to the snippet
        snippet = addLineBreaks(to: snippet, count: extraLines);

        // Set the clipboard contents to the snippet.
        // Mark as transient to prevent the snippet being shown in history ref: http://nspasteboard.org/
        let TransientType = NSPasteboard.PasteboardType("org.nspasteboard.TransientType")
        let pb = NSPasteboard.general
        pb.prepareForNewContents(with: NSPasteboard.ContentsOptions())
        pb.clearContents()
        pb.setString(snippet, forType: .string)
        pb.setString("", forType: TransientType)

        // Paste the clipboard contents using keyboard shortcuts.
        let source = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false)
        keyDown?.flags = .maskCommand
        keyUp?.flags = .maskCommand
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)

        // Wait for the paste to complete.
        usleep(100000) // Wait for 100 milliseconds.

        // Set the clipboard contents back to the original value, if it was not empty.
        if !clipboardData.isEmpty {
            NSPasteboard.general.clearContents()
            for (type, data) in clipboardData {
                NSPasteboard.general.setData(data, forType: NSPasteboard.PasteboardType(rawValue: type))
            }
            // Mark as restored https://groups.google.com/g/nspasteboard/c/bWfOvhYNek8
            let RestoredType = NSPasteboard.PasteboardType("org.nspasteboard.RestoredType")
            NSPasteboard.general.setString("", forType: RestoredType)
        }

    }

    // Function to concatenate a number of line breaks to the snippet
    func addLineBreaks(to string: String, count: Int) -> String {
        var result = string
        for _ in 0..<count {
            result += "\n"
        }
        return result
    }
}

