

import Vapor

extension Request {
    public var smtp: SMTP {
        return application.smtp
    }
}

