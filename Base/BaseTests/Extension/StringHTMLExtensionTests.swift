//
//  StringHTMLExtensionTests.swift
//  Base
//
//  Created by 이상호 on 1/11/26.
//

import Testing
@testable import Base

struct StringHTMLExtensionTests {
    @Test("&#039; 등 HTML 엔티티가 디코딩된다.")
    func decodesHTMLEntities() {
        // given
        let raw = "Apple&#039;s History in One Video"
        
        // when
        let decoded = raw.htmlDecoded
        
        // then
        #expect(decoded == "Apple's History in One Video")
    }
    
    @Test("기본 HTML 태그가 텍스트로 변환된다.")
    func stripsHTMLTags() {
        // given
        let raw = "<p>Hello<br>World</p>"
        
        // when
        let decoded = raw.htmlDecoded
        
        // then
        #expect(decoded.contains("Hello"))
        #expect(decoded.contains("World"))
        #expect(decoded.contains("<") == false)
        #expect(decoded.contains(">") == false)
    }
    
    @Test("HTML이 없는 문자열은 그대로 유지된다.")
    func plainText_returnsSame() {
        // given
        let raw = "Plain text"
        
        // when
        let decoded = raw.htmlDecoded
        
        // then
        #expect(decoded == raw)
    }
    
    @Test("한글/이모지가 포함되어도 정상 동작한다.")
    func unicode_roundTrip() {
        // given
        let raw = "<p>안녕 &#039;스위프트&#039; 😄</p>"
        
        // when
        let decoded = raw.htmlDecoded
        
        // then
        #expect(decoded.contains("안녕"))
        #expect(decoded.contains("'스위프트'"))
        #expect(decoded.contains("😄"))
    }
    
    @Test("깨진 HTML에서도 크래시 없이 동작한다.")
    func malformedHTML_doesNotCrash() {
        // given
        let raw = "<p><b>Broken &amp; Unclosed"
        
        // when
        let decoded = raw.htmlDecoded
        
        // then
        #expect(decoded.contains("Broken"))
        #expect(decoded.contains("&") || decoded.contains("amp") == false)
    }
}
