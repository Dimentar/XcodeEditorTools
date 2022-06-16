//
//  StringCaseCommand.swift
//  MyTools
//
//  Created by Alexandru Moisei on 25/05/22.
//

import Foundation
import XcodeKit

class StringCaseCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        defer { completionHandler(nil) }

        let buffer = invocation.buffer
        let selectedRanges: SelectionType = selectionRanges(of: buffer)
        let selectionIndexSet: IndexSet = selectedLinesIndexSet(for: selectedRanges)
        var substitutions = buffer.lines.objects(at: selectionIndexSet).compactMap { $0 as? String }

        switch Action(command: invocation.commandIdentifier)! {
        case .toCamelCase:
            substitutions = substitutions.map { $0.toCamelCase() }
        case .toSnakeCase:
            substitutions = substitutions.map { $0.toSnakeCase(lower: true) }
        case .toScreamingCase:
            substitutions = substitutions.map { $0.toSnakeCase(lower: false) }
        }
        buffer.lines.replaceObjects(at: selectionIndexSet, with: substitutions)
    }

    enum Action: String {
        case toCamelCase
        case toSnakeCase
        case toScreamingCase

        init?(command: String) {
            // Example: dev.alex.XcodeEditorTools.MyTools.toCamelCase
            guard let value = command.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: value)
        }
    }
}

// sake_case
extension String {
    func toSnakeCase(lower: Bool = true) -> String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let fullWordsPattern = "([a-z])([A-Z]|[0-9])"
        let digitsFirstPattern = "([0-9])([A-Z])"
        let processed = processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: fullWordsPattern)?
            .processCamelCaseRegex(pattern: digitsFirstPattern)?
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "__", with: "_")
            ?? self
        return lower ? processed.lowercased() : processed.uppercased()
    }

    private func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}

// camelCase
extension String {
    func toCamelCase() -> String {
        if uppercased() == self || contains("_") {
            return camelCased(with: "_")
        } else if contains("-") {
            return camelCased(with: "-")
        } else {
            return self
        }
    }

    func camelCased(with separator: Character) -> String {
        lowercased()
            .split(separator: separator)
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }
}
