

import Vapor

extension Application {
    public var smtp: SMTP {
        if let existing = self.storage[SMTPKey.self] {
            return existing
        } else {
            let new = SMTP(application: self)
            self.storage[SMTPKey.self] = new
            return new
        }
    }

    private struct SMTPKey: StorageKey {
        typealias Value = SMTP
    }
}

