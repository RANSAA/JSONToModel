//
//  DefaultWrapped.swift
//  WrapperString
//
//  Created by PC on 2021/8/9.
//
/**
 自定义属性包装器，为属性提供一个默认值
 */
import Foundation


@propertyWrapper
struct WrapperString {
    private var value: String! = ""
    private var raw: String!
    var wrappedValue: String!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: String!) {
        raw = wrappedValue
    }
}


@propertyWrapper
struct WrapperInt {
    private var value: Int! = 0
    private var raw: Int!
    var wrappedValue: Int!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: Int!) {
        raw = wrappedValue
    }
}

@propertyWrapper
struct WrapperFloat {
    private var value: Float! = 0.0
    private var raw: Float!
    var wrappedValue: Float!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: Float!) {
        raw = wrappedValue
    }
}


@propertyWrapper
struct WrapperDouble {
    private var value: Double! = 0.0
    private var raw: Double!
    var wrappedValue: Double!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: Double!) {
        raw = wrappedValue
    }
}


@propertyWrapper
struct WrapperBool {
    private var value: Bool! = false
    private var raw: Bool!
    var wrappedValue: Bool!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: Bool!) {
        raw = wrappedValue
    }
}



@propertyWrapper
struct WrapperArray {
    private var value: [Any]! = []
    private var raw: [Any]!
    var wrappedValue: [Any]!{
        set{raw = newValue}
        get{raw ?? value}
    }

    init() {}
    init(wrappedValue: [Any]!) {
        raw = wrappedValue
    }
}
