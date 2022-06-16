//
//  SourceEditorCommand.swift
//  MyTools
//
//  Created by Alexandru Moisei on 19/05/22.
//

import Foundation
import XcodeKit

enum Action: String {
    case duplicateSelectedLines

    init?(command: String) {
        // Example: dev.alex.XcodeEditorTools.MyTools.duplicateSelectedLines
        guard let value = command.components(separatedBy: ".").last else { return nil }
        self.init(rawValue: value)
    }
}

class DuplicateSelectedLinesCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let buffer = invocation.buffer
        let selectedRanges: SelectionType = selectionRanges(of: buffer)
        let selectionIndexSet: IndexSet = selectedLinesIndexSet(for: selectedRanges)
        let range = buffer.selections.firstObject as! XCSourceTextRange
        let copyOfLines = buffer.lines.objects(at: selectionIndexSet)

        buffer.lines.insert(copyOfLines, at: selectionIndexSet)

        switch selectedRanges {
        case .none(_, let column):
            if column == 0 {
                range.start.line += 1
                range.end.line += 1
            }
        case .words: // TODO:
            break

        case .lines(_, let endPosition):
            range.start = endPosition
            range.start.line += 1

        case .multiLocation:
            break
        }

        completionHandler(nil)
    }
}
