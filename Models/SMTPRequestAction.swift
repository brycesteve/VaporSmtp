//
//  File.swift
//  
//
//  Created by Steve Bryce on 13/02/2020.
//

enum SMTPRequestAction {
    case sayHello(serverName: String)
    case startTLS
    case beginAuthentication
    case authUser(String)
    case authPassword(String)
    case mailFrom(String)
    case recipient(String)
    case data
    case transferData(Email)
    case quit
}
