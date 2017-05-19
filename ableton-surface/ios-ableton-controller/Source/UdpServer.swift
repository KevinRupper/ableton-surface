//
//  UdpServer.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 13/3/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import Foundation
import UIKit


public class UdpServer:NSObject {
    
    var readSource:DispatchSourceRead?
    let queue:DispatchQueue!
    
    private let socket:Socket!
    
    init(socket: Socket) {
        self.socket = socket
        self.queue = DispatchQueue(label: "com.ios.control.queue", qos: .background, target: nil)
    }
    
    func start() -> Result {
        // Create the socket
        var result = self.socket.create(domain: AF_INET, type: SOCK_DGRAM)
        
        guard result == Result.success else {
            return Result.socketError
        }
        
        let fd = self.socket.getSocket()
        
        // Bind socket
        result = self.socket.bindSocket(family: AF_INET, port: 9000, address: in_addr(s_addr: INADDR_ANY))
        
        guard result == Result.success else {
            return Result.bindError
        }
        
        // Listen for socket events
        self.readSource = DispatchSource.makeReadSource(fileDescriptor: fd, queue: self.queue)
        
        guard self.readSource != nil else {
            return Result.sourceError
        }
        
        // Set source handlers
        self.readSource?.setCancelHandler(handler: DispatchWorkItem(block: {
            print("Cancel handler \(strerror(errno))")
            close(self.socket.getSocket())
        }))
        
        self.readSource?.setEventHandler(handler: DispatchWorkItem(block: {
            print("Read source event handler")

            var senderAddress = sockaddr_in()
            var socketAddressLength = socklen_t(MemoryLayout<sockaddr_in>.stride)
            let response = [UInt8](repeating: 0, count: 4096)
            
            let bytesRead = self.socket.receiveFrom(buffer: response, addr: &senderAddress, lenght: &socketAddressLength, flags: 0)
            
            // TODO:
            // Check information, it's a OSCMessage?
            
            let dataRead = response[0..<bytesRead]
            print("read \(bytesRead) bytes: \(dataRead)")
            if let dataString = String(bytes: dataRead, encoding: String.Encoding.utf8) {
                print("The message was: \(dataString)")
            }
        }))
        
        self.readSource?.resume()
        
        print("UpdServer: connection success")
        
        return Result.success
    }

    deinit {
        if self.readSource != nil {
            self.readSource?.cancel()
            self.readSource = nil
        }
        
        print("UdpClient is being deinitialized")
    }
}
