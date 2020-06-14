

import Vapor

extension Application {
    public var smtp: SMTP {
        if let existing = self.storage[SMTPKey.self] {
            return existing
        } else {
            let lock = self.locks.lock(for: SMTPKey.self)
            return lock.withLock {
                let new = SMTP(application: self)
                self.storage[SMTPKey.self] = new
                return new
            }
        }
    }

    private struct SMTPKey: StorageKey, LockKey {
        typealias Value = SMTP
    }
}

