//
//  File.swift
//  
//
//  Created by Steve Bryce on 16/02/2020.
//

import Vapor

extension Request {
    public var smtp: SMTP {
        return application.smtp
    }
}

