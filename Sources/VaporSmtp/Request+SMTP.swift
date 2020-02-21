

import Vapor

extension Request {
    public var smtp: SMTP {
        return SMTP(application: application, on: self.eventLoop)
    }
}

