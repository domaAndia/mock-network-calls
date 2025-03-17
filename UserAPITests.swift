// UserAPITests.swift

import Foundation
import XCTest

@testable import MyApp

class UserAPITests: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    lazy var api: UserAPI = {
        UserAPI(session: session)
    }()

    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testFetchUser() async throws{
        let mockData = """
        {
            "firstName": "Test_First_Name",
            "lastName": "Test_Last_Name"
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://my-api.com/user/me")
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, mockData)
        }

        let result = try await api.fetchUser()
        
        XCTAssertEqual(result.firstName, "Test_First_Name")
        XCTAssertEqual(result.lastName, "Test_Last_Name")
    }
}
