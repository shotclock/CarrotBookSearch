//
//  ArraySafeSubscriptTests.swift
//  Base
//
//  Created by 이상호 on 1/11/26.
//

import Testing
@testable import Base

struct ArraySafeSubscriptTests {
    @Test("range 내의 인덱스로 읽는 경우 정상 값을 반환한다.")
    func read_inRange_returnsElement() {
        // given
        let array = [10, 20, 30]
        
        // when
        let value = array[safe: 1]
        
        // then
        #expect(value == 20)
    }

    
    @Test("range 밖의 인덱스로 읽는 경우 nil 값을 반환한다.")
    func read_outOfRange_returnsNil() {
        // given
        let array = [10, 20, 30]
        
        // when
        let abnormalValue1 = array[safe: 3]
        let abnormalValue2 = array[safe: -1]
        
        // then
        #expect(abnormalValue1 == nil)
        #expect(abnormalValue2 == nil)
    }
    
    @Test("range 내의 인덱스로 값을 쓰는 경우 정상적으로 값을 바꾼다.")
    func write_inRange_updatesElement() {
        // given
        var array = [10, 20, 30]
        
        // when
        array[safe: 1] = 99
        
        // then
        #expect(array == [10, 99, 30])
    }

    @Test("range 밖의 인덱스로 값을 쓰는 경우 값을 바꾸지 않는다.")
    func write_outOfRange_doesNothing() {
        // given
        var array = [10, 20, 30]
        
        // when
        array[safe: 3] = 99
        array[safe: -1] = 99
        
        // then
        #expect(array == [10, 20, 30])
    }

    @Test("safe로 접근한 인덱스의 값을 nil로 쓰려 하면 값이 바뀌지 않는다.")
    func write_nil_doesNothing() {
        // given
        var array = [10, 20, 30]
        
        // when
        array[safe: 1] = nil
        
        // then
        #expect(array == [10, 20, 30])
    }
}
