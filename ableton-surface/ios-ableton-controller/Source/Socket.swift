//
//  Socket.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 16/3/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import Foundation

enum Result {
    case success
    case socketError
    case bindError
    case sendError
    case sourceError
}

public class Socket:NSObject {
    
    var sd:Int32?
    
    func create(domain: Int32, type: Int32) -> Result {
        return create(domain: domain, type: type, proto: 0)
    }
    
    func create(domain: Int32, type: Int32, proto: Int32) -> Result {
        self.sd = socket(domain, type, proto)
        
        guard self.sd! > 0 else {
            let error = strerror(errno)
            print("Socket error: \(String(describing: error))")
            return Result.socketError
        }
        
        return Result.success
    }
    
    func bindSocket() -> Result {
        // Default
        return bindSocket(family: AF_INET, port: 0, address: in_addr(s_addr:INADDR_ANY))
    }
    
    func bindSocket(family: Int32, port: UInt16, address:String) -> Result {
        // Socket address
        var sin_addr = in_addr()
        inet_pton(family, address, &sin_addr)
        
        return bindSocket(family: family, port: port, address: sin_addr)
    }
    
    func bindSocket(family: Int32, port: UInt16, address:in_addr) -> Result {
        
        var addr = sockaddr_in(
            sin_len:    __uint8_t(MemoryLayout<sockaddr_in>.size),
            sin_family: sa_family_t(family),
            sin_port:   CFSwapInt16(port),
            sin_addr:   address,
            sin_zero:   (0, 0, 0, 0, 0, 0, 0, 0)
        )
        
        // Bind the socket to the address
        let result = withUnsafePointer(to: &addr) {
            // Temporarily bind the memory at &addr to a single instance of type sockaddr.
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                bind(self.sd!, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
            }
        }
        
        guard result == 0 else {
            let error = String(validatingUTF8: strerror(errno))
            print("Bind error: \(String(describing: error))")
            return Result.bindError
        }
        
        return Result.success
    }
    
    func sendData(data:[UInt8], flags:Int32) -> Int {
        // Used on a connection mode (SOCK_STREAM, SOCK_SEQPACKET)
        let sent = send(self.sd!, data, data.count, flags)
        
        guard sent > 0 else {
            let error = String(validatingUTF8: strerror(errno))
            print("Send error: \(String(describing: error))")
            return sent
        }
        
        return sent
    }
    
    func sendTo(data:[UInt8], addr: inout sockaddr_in, flags:Int32) -> Int {
        let bytes = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                sendto(self.sd!, data, data.count, flags, UnsafePointer<sockaddr>($0), socklen_t(addr.sin_len))
            }
        }
        
        guard bytes > 0 else {
            let error = String(validatingUTF8: strerror(errno))
            print("Send to error: \(String(describing: error))")
            return bytes
        }
        
        return bytes
    }
    
    func receive(data: inout [UInt8], flags:Int32) -> Int {
        return recv(self.sd!, &data, data.count, flags)
    }
    
    func receiveFrom(buffer:[UInt8], addr: inout sockaddr_in, lenght:UnsafeMutablePointer<socklen_t>, flags:Int32) -> Int {
        let bytes = withUnsafeMutablePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                recvfrom(self.sd!, UnsafeMutableRawPointer(mutating: buffer), buffer.count, flags, UnsafeMutablePointer<sockaddr>($0), lenght)
            }
        }

        guard bytes > -1 else {
            let error = String(validatingUTF8: strerror(errno))
            print("Recvfrom to error: \(String(describing: error))")
            return bytes
        }
        
        return bytes
    }
    
    func closeSocket(){
        if self.sd != nil {
            close(self.sd!)
        }
    }
    
    func getSocket() -> Int32 {
        if self.sd != nil {
            return self.sd!
        }
        
        return -1
    }
    
    deinit {
        if self.sd != nil {
            close(self.sd!)
        }
    }
}
