//
//  Cache.swift
//  Caching
//
//  Created by Jonathan Como on 10/21/17.
//  Copyright © 2017 Jonathan Como. All rights reserved.
//

import Foundation

protocol Cache {
    func get(user: User, path: String) -> Data?
    func put(user: User, path: String, contents: Data) -> Error?
}

class FileCache : Cache {
    var ttl: TimeInterval
    
    init(ttl: TimeInterval) {
        self.ttl = ttl
    }
    
    func get(user: User, path: String) -> Data? {
        let url = filePath(user: user, forPath: path)
        if !hasExpired(url: url) {
            return try? Data(contentsOf: url)
        } else {
            return nil
        }
    }
    
    func put(user: User, path: String, contents: Data) -> Error? {
        let url = filePath(user: user, forPath: path)
        
        do {
            try createAccountDir(user: user)
            try contents.write(to: url, options: .atomic)
            return nil
        } catch let err {
            return err
        }
    }
    
    private func hasExpired(url: URL) -> Bool {
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path) {
            let modifiedDate = attrs[.modificationDate] as! Date
            return abs(modifiedDate.timeIntervalSinceNow) > ttl
        } else {
            return false
        }
    }
    
    private func createAccountDir(user: User) throws {
        let url = accountDir(user: user)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func accountDir(user: User) -> URL {
        // [filesystem root]/Library/Caches/[account_id]/[base64_encoded_path]
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            .appendingPathComponent(user.screenname!, isDirectory: true)
    }
    
    private func filePath(user: User, forPath: String) -> URL {
        // /uuid -> 3NEFNAJN11
        let encodedPath = forPath.data(using: .utf8)!.base64EncodedString()
        print(encodedPath)
        return accountDir(user: user).appendingPathComponent(encodedPath, isDirectory: false)
    }
}

