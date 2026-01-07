//
//  URLBuilderTests.swift
//  NetworkTests
//
//  Created by 이상호 on 1/7/26.
//

import Foundation
import Testing
@testable import Network

struct URLBuilderTests {
    let dummyScheme = "https"
    let dummyHost = "api.test.local"
    let dummyPath = "/v1/test-endpoint"
    let dummyQuery = ["key": "value"]

    @Test("체인 방식으로 URL을 조합하면 올바른 URL이 생성된다.")
    func buildURL_withChain_generatesExpectedComponents() {
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(dummyPath)
            .addQuery(dummyQuery)
            .build()
        
        // then
        #expect(url != nil)
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        
        #expect(components?.scheme == "https")
        #expect(components?.host == "api.test.local")
        #expect(components?.path == "/v1/test-endpoint")
        #expect(components?.queryItems?.contains(where: { $0.name == "key" && $0.value == "value" }) == true)
    }
    
    @Test("쿼리 파라미터에 nil 값이 있으면 URL에 포함되지 않는다.")
    func addQuery_filtersOutNilValues() {
        // given
        let dummyQueryWithNilValue = ["key": nil,
                                      "key2": "value2"]
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(dummyPath)
            .addQuery(dummyQueryWithNilValue)
            .build()!
        
        // then
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        
        #expect(queryItems.count == 1)
        #expect(queryItems.first?.name == "key2")
        #expect(queryItems.first?.value == "value2")
    }
    
    @Test("addQuery를 여러번 호출하면 쿼리 파라미터가 누적된다.")
    func addQuery_appendsQueryItems() {
        // given
        let dummyQuery = ["a": 1]
        let dummyQuery2 = ["b": 2]
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(dummyPath)
            .addQuery(dummyQuery)
            .addQuery(dummyQuery2)
            .build()!
        
        // then
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(Set(items.map { $0.name }) == Set(["a", "b"]))
    }
    
    @Test("쿼리 값에 공백이나 특수문자가 있어도 URL 생성에 실패하지 않는다.")
    func addQuery_encodesSpecialCharacters() {
        // given
        let query: [String: Any?] = [
            "q": "ios book"
        ]
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(dummyPath)
            .addQuery(query)
            .build()
        
        // then
        #expect(url != nil)

        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        #expect(queryItems.contains(where: { $0.name == "q" }))
    }
}
