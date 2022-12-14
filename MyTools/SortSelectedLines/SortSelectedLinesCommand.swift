import Foundation
import XcodeKit

class SortSelectedLinesCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Swift.Error?) -> Void) {
        defer { completionHandler(nil) }
        
        // At least something is selected
        guard let firstSelection = invocation.buffer.selections.firstObject as? XCSourceTextRange,
              let lastSelection = invocation.buffer.selections.lastObject as? XCSourceTextRange
        else {
            return
        }
        
        // One line selected
        guard firstSelection.start.line < lastSelection.end.line else {
            return
        }
        
        let range = (firstSelection.start.line ... lastSelection.end.line).saneRange(for: invocation.buffer.lines.count)
        
        LinesSorter().sort(invocation.buffer.lines, in: range, by: isLowerIgnoringLeadingWhitespacesAndTabs)
        
        let lastSelectedLine = invocation.buffer.lines[range.upperBound] as? String
        
        firstSelection.start.column = 0
        lastSelection.end.column = lastSelectedLine?.count ?? 0
    }
}
