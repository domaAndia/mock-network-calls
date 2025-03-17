// UserAPI.swift

import Foundation

struct User: Decodable {
    let firstName: String
    let lastName: String
}

final class UserAPI {
    let endpoint = URL(string: "https://my-api.com")!
    
    let session: URLSession
    let decoder: JSONDecoder
    
    init(
        session: URLSession = URLSession.shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchUser() async throws -> User {
        return try await request(url: endpoint.appendingPathComponent("user/me"))
    }
    
    private func request<T>(url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
}
