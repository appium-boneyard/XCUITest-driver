//
//  TalkWithHostUITests.swift
//  TalkWithHostUITests
//
//  Created by jdeff on 6/25/15.
//  Copyright © 2015 nestlabs. All rights reserved.
//

import Foundation
import XCTest

class TalkWithHostUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMakeANetworkRequest() {
        let semephore = dispatch_semaphore_create(0)

        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://httpbin.org/get")!) { (data: NSData?, response: NSURLResponse?, error: NSError?) in

            var json : AnyObject

            if let data = data {
                do {
                    try json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)

                    print(json.debugDescription)
                } catch _ {
                    print("An error occurred while parsing JSON")
                }
            }

            dispatch_semaphore_signal(semephore)
        }

        task!.resume()

        dispatch_semaphore_wait(semephore, DISPATCH_TIME_FOREVER)
    }

    func testSetupATCPServer() {
        func printSuccess(_: CFSocket!, _:CFSocketCallBackType, _:CFData!, _:UnsafePointer<Void>, _:UnsafeMutablePointer<Void>) {
            print("Callback called!!")
        }

        let server : CFSocket = CFSocketCreate(
            kCFAllocatorDefault,
            PF_INET6,
            SOCK_STREAM,
            IPPROTO_TCP,
            CFSocketCallBackType.AcceptCallBack.rawValue,
            printSuccess as CFSocketCallBack,
            nil
        )

        var sin = sockaddr_in6()

        sin.sin6_family = UInt8(AF_INET6)
        sin.sin6_port = 5432
        sin.sin6_addr = in6addr_any

        let sincfd = NSData(bytes: &sin, length: sizeof(sockaddr_in6))

        CFSocketSetAddress(server, sincfd)

        let socketsource6 = CFSocketCreateRunLoopSource(
            kCFAllocatorDefault,
            server,
            0
        )

        print("Adding source to run loop")
        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),
            socketsource6,
            kCFRunLoopDefaultMode as CFString
        )
    }

//    func testCodeIGotFromStackoverflow() {
//        let ap_servicePortNumber = UInt8(5544)
//
//        var status: Int32?
//
//        // Protocol configuration
//        var hints = addrinfo(
//            ai_flags: AI_PASSIVE,       // Assign the address of my local host to the socket structures
//            ai_family: AF_UNSPEC,       // Either IPv4 or IPv6
//            ai_socktype: SOCK_STREAM,   // TCP
//            ai_protocol: 0,
//            ai_addrlen: 0,
//            ai_canonname: nil,
//            ai_addr: nil,
//            ai_next: nil)
//
//        // For the result from the getaddrinfo
//        var servinfo : UnsafeMutablePointer<addrinfo> = nil
//
//        // Get the info we need to create our socket descriptor
//
//        status = getaddrinfo(nil, ap_servicePortNumber, &hints, &servinfo)
//
//
//        // Cop out if there is an error
//
//        if status != 0 { return }
//
//
//        // Print a list of the found IP addresses
//
//        if ap_applicationInDebugMode {
//
//            var info = servinfo
//
//            while info != UnsafeMutablePointer<addrinfo>.null() {
//
//                // Check for IPv4
//                if info.memory.ai_family == AF_INET {
//
//                    var ipAddressString = [CChar](count:Int(INET_ADDRSTRLEN), repeatedValue: 0)
//                    inet_ntop(
//                        info.memory.ai_family,
//                        info.memory.ai_addr,
//                        &ipAddressString,
//                        socklen_t(INET_ADDRSTRLEN))
//                    let addressStr = String.fromCString(&ipAddressString)
//                    var message = addressStr == nil ? "No IPv4 address found" : "IPv4 address: " + addressStr!
//                    log.atLevelDebug(source: SOURCE, object: nil, message: message)
//
//                } else { // Should be IPv6
//
//                    var ipAddressString = [CChar](count:Int(INET6_ADDRSTRLEN), repeatedValue: 0)
//                    inet_ntop(
//                        info.memory.ai_family,
//                        info.memory.ai_addr,
//                        &ipAddressString,
//                        socklen_t(INET6_ADDRSTRLEN))
//                    let addressStr = String.fromCString(&ipAddressString)
//                    var message = addressStr == nil ? "No IPv6 address found" : "IPv6 address: " + addressStr!
//                    log.atLevelDebug(source: SOURCE, object: nil, message: message)
//                }
//
//                info = info.memory.ai_next
//            }
//        }
//
//
//        // Get the socket descriptor, use the results from the getaddrinfo call earlier
//
//        var socketDescriptor = socket(servinfo.memory.ai_family, servinfo.memory.ai_socktype, servinfo.memory.ai_protocol);
//
//        log.atLevelDebug(source: SOURCE, object: nil, message: "Socket value: " + socketDescriptor.description)
//
//
//        // Since we will be listening, bind the socket descriptor to our socket
//        
//        status = bind(socketDescriptor, servinfo.memory.ai_addr, servinfo.memory.ai_addrlen);
//        
//        log.atLevelDebug(source: SOURCE, object: nil, message: "Status from binding: " + status.description)
//        
//        
//        // Cop out if there is an error
//        
//        // PS: Need to handle "in use" errors
//        
//        if status != 0 {
//            let message = "Binding error, status = " + status.description + ", error = " + errno.description
//            log.atLevelEmergency(source: SOURCE, object: nil, message: message)
//            setApplicationError(ErrorCode.initPortForListeningBindingError, message)
//            return
//        }
//        
//        
//        // Don't need this anymore
//        
//        freeaddrinfo(servinfo)
//    }
}
