//
//  PasswordManagerTests.swift
//  nbc-kickboard
//
//  Created by 권승용 on 12/17/24.
//

import Testing
@testable import nbc_kickboard

struct PasswordManagerTests {
    @Test func testEncryption() async throws {
        let manager = PasswordManager()
        print(try manager.encryptPassword("samplePassword"))
    }
}
