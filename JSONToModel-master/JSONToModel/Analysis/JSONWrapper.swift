//
//  JSONWrapper.swift
//  JSONWrapper
//
//  Created by PC on 2021/8/9.
//
/**
 自定义属性包装器，为属性提供一个默认值
 主要用于json Model中
 */
import Foundation


@propertyWrapper
struct JSONWrapperString {
    private var raw: String!
    var wrappedValue: String!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = "null" }
    init(wrappedValue: String!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}


@propertyWrapper
struct JSONWrapperInt {
    private var raw: Int!
    var wrappedValue: Int!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = 0 }
    init(wrappedValue: Int!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}

@propertyWrapper
struct JSONWrapperFloat {
    private var raw: Float!
    var wrappedValue: Float!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = 0.0 }
    init(wrappedValue: Float!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}


@propertyWrapper
struct JSONWrapperDouble {
    private var raw: Double!
    var wrappedValue: Double!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = 0.0 }
    init(wrappedValue: Double!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}


@propertyWrapper
struct JSONWrapperBool {
    private var raw: Bool!
    var wrappedValue: Bool!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = false }
    init(wrappedValue: Bool!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}


@propertyWrapper
struct JSONWrapperArray {
    private var raw: [Any]!
    var wrappedValue: [Any]!{
        set{
            if newValue != nil {
                raw = newValue
            }
        }
        get{ return raw }
    }

    init() { raw = [] }
    init(wrappedValue: [Any]!) {
        self.init()
        if wrappedValue != nil {
            raw = wrappedValue
        }
    }
}
