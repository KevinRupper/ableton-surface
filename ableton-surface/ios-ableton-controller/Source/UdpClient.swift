//
//  UdpClient.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 6/3/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

//    struct sockaddr_in {
//        uint8_t         sin_len;      /* length of structure (16) */
//        sa_family_t     sin_family;   /* AF_INET */
//        in_port_t       sin_port;     /* 16-bit TCP or UDP port number */
//        /* network byte ordered */
//        struct in_addr  sin_addr;     /* 32-bit IPv4 address */
//        /* network byte ordered */
//        char            sin_zero[8];  /* unused */
//    };

import Foundation
import UIKit

class UdpClient:NSObject {

    func send() {
        
        let sockfd = socket(AF_INET, SOCK_DGRAM, 0)

        // Check socket error
        guard sockfd >= 0 else {
            let error = strerror(errno)
            print("[# Fail] Socket creation: \(String(describing: error))")
            return
        }

        // Socket address
        var sin_addr = in_addr()
        inet_pton(AF_INET, "127.0.0.1", &sin_addr)

        var addr = sockaddr_in(
            sin_len:    __uint8_t(MemoryLayout<sockaddr_in>.size),
            sin_family: sa_family_t(AF_INET),
            sin_port:   CFSwapInt16(9000),
            sin_addr:   sin_addr,
            sin_zero:   (0, 0, 0, 0, 0, 0, 0, 0)
        )
    
        let outData = Array("Hello World!".utf8)
        
        let sent = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                sendto(sockfd, outData, outData.count, 0, UnsafePointer<sockaddr>($0), socklen_t(addr.sin_len))
            }
        }
        
        if sent == -1 {
            let errmsg = String(validatingUTF8: strerror(errno))
            print("Send failed: \(errno) \(String(describing: errmsg))")
            return
        }
        
        print("Sent \(sent) bytes as \(outData)")
    }
    
    deinit {
        print("UdpClient is being deinitialized")
    }
}
