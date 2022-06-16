struct Variable {
    let name: String
    let type: String
    let isMutable: Bool

    var containsDefaultValue: Bool {
        return type.contains("=")
    }

    var isComputed: Bool {
        return type.contains(" {")
    }
}

extension Variable {
    var needToSkipInInitGeneration: Bool {
        if !isMutable, containsDefaultValue {
            return true
        }

        if isComputed {
            return true
        }

        return false
    }
}
