

import Vapor
import NIO
import NIOExtras
import NIOTLS
import NIOSSL

public struct SMTP {
    public var eventLoopGroup: EventLoopGroup {
        self.application.eventLoopGroup
    }

    struct ConfigurationKey: StorageKey {
        typealias Value = SMTPServerConfig
    }

    public var configuration: SMTPServerConfig {
        get {
            guard self.application.storage[ConfigurationKey.self] != nil  else{
                fatalError("Set SMTP Config using app.smtp.use()")
            }
            return self.application.storage[ConfigurationKey.self]!
            
        }
        nonmutating set {
            self.application.storage[ConfigurationKey.self] = newValue
        }
    }

    
    let application: Application
    
    public func use(_ config: SMTPServerConfig) {
        self.configuration = config
    }
    
    func configureBootstrap(group: EventLoopGroup,
                            email: Email,
                            emailSentPromise: EventLoopPromise<Void>) -> ClientBootstrap {
        return ClientBootstrap(group: group).channelInitializer { channel in
            var handlers: [ChannelHandler] = [
                ByteToMessageHandler(LineBasedFrameDecoder()),
                SMTPResponseDecoder(),
                MessageToByteHandler(SMTPRequestEncoder()),
                SendEmailHandler(configuration: self.configuration,
                                 email: email,
                                 allDonePromise: emailSentPromise)
            ]
            
            switch self.configuration.tlsConfiguration {
            case .regularTLS:
                do {
                    let sslContext = try NIOSSLContext(configuration: .forClient())
                    let sslHandler = try NIOSSLClientHandler(context: sslContext, serverHostname: self.configuration.hostname)
                    handlers.insert(sslHandler, at: 0)
                }
                catch {
                    return channel.eventLoop.makeFailedFuture(error)
                }
            //No additional ssl for other modes
            default:
                ()
            }
            return channel.pipeline.addHandlers(handlers, position: .last)
        }
    }
    
    public func send(_ email: Email) -> EventLoopFuture<Error?> {
        let emailSentPromise: EventLoopPromise<Void> = self.eventLoopGroup.next().makePromise()
        let completedPromise: EventLoopPromise<Error?> = self.eventLoopGroup.next().makePromise(of: Error?.self)
        let bootstrap: ClientBootstrap
        
        bootstrap = configureBootstrap(group: self.eventLoopGroup,
                                       email: email,
                                       emailSentPromise: emailSentPromise)
        self.application.logger.debug("Configured Bootstrap")
        
        let connection = bootstrap.connect(host: self.configuration.hostname, port: self.configuration.port)
        
        connection.cascadeFailure(to: emailSentPromise)
        
        emailSentPromise.futureResult.map {
            connection.whenSuccess { $0.close(promise: nil) }
            completedPromise.succeed(nil)
        }.whenFailure { error in
            self.application.logger.error("\(error.localizedDescription)")
            connection.whenSuccess { $0.close(promise: nil) }
            completedPromise.succeed(error)
        }
        return completedPromise.futureResult
    }
}




