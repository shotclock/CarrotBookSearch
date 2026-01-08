//
//  URLBuilderTests.swift
//  NetworkingTests
//
//  Created by 이상호 on 1/7/26.
//

import Foundation
import Testing
@testable import Networking

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
            .build()
        
        // then
        #expect(url != nil)
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        
        #expect(components?.scheme == "https")
        #expect(components?.host == "api.test.local")
        #expect(components?.path == "/v1/test-endpoint")
    }
    
    @Test("scheme/host/path를 여러번 호출하면 마지막 값이 적용된다.")
    func chaining_appendsLastItems() {
        // given
        let dummyScheme2 = "http"
        let dummyHost2 = "test.local"
        let dummyPath2 = "/v2/test-endpoint"
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addScheme(dummyScheme2)
            .addHost(dummyHost)
            .addHost(dummyHost2)
            .addPath(dummyPath)
            .addPath(dummyPath2)
            .build()
        
        // then
        #expect(url != nil)
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        #expect(components?.scheme == dummyScheme2)
        #expect(components?.host == dummyHost2)
        #expect(components?.path == dummyPath2)
    }
    
    @Test("path가 /로 시작하면 정상적인 path로 적용된다.")
    func buildURL_pathWithLeadingSlash() {
        // given
        let pathWithSlash = "/v1/books"
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(pathWithSlash)
            .build()
        
        // then
        #expect(url != nil)
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        #expect(components?.path == "/v1/books")
    }
    
    @Test("path가 / 없이 들어오면 그대로 이어붙여져 비정상적인 URL이 생성될 수 있다.")
    func buildURL_pathWithoutLeadingSlash() {
        // given
        let pathWithoutSlash = "v1/books"
        
        // when
        let url = URLBuilder()
            .addScheme(dummyScheme)
            .addHost(dummyHost)
            .addPath(pathWithoutSlash)
            .build()
        
        // then
        #expect(url == nil)
    }
}
