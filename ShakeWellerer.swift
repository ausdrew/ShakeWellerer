import Cocoa
import Foundation

// Gather strings from Alfred workflow.
let selector = ProcessInfo.processInfo.environment["Selector"] ?? ""

let snippets = ProcessInfo.processInfo.environment[selector] ?? "Failed to get snippets."
let snippetArray = snippets.split(separator: "--").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }

// Get the current clipboard contents and store it in a variable.
var clipboardData: [String: Data] = [:]
if let clipboardTypes = NSPasteboard.general.types {
    for type in clipboardTypes {
        clipboardData[type.rawValue] = NSPasteboard.general.data(forType: type)
    }
}

// Select a random string from the array.
var snippet = snippetArray.randomElement() ?? ""

// Function to concatenate a number of line breaks to the snippet
func addLineBreaks(to string: String, count: Int) -> String {
    var result = string
    for _ in 0..<count {
        result += "\n"
    }
    return result
}

// Convert the alfred config variable for number of lines to an int
let extraLinesSelector = ProcessInfo.processInfo.environment["ExtraLines"] ?? ""
let numberofLineBreaks = Int(ProcessInfo.processInfo.environment[extraLinesSelector] ?? "2") ?? 2

// add the specified number of line breaks to the snippet
snippet = addLineBreaks(to: snippet, count: numberofLineBreaks);

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