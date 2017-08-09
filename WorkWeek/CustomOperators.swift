//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//


// The below operator is from 
// https://github.com/robrix/Prelude/blob/master/Prelude/Application.swift
//  Copyright (c) 2014 Rob Rix. All rights reserved.


precedencegroup ForwardApplication {
    /// Associates to the left so that pipeline behaves as expected.
    associativity: left
    higherThan: AssignmentPrecedence
}


infix operator |> : ForwardApplication


// MARK: Forward function application
/// Forward function application.
///
/// Applies the function on the right to the value on the left. Functions
///of >1 argument can be applied by placing their arguments in a tuple on the left hand side.
///
/// This is a useful way of clarifying the flow of data through a series of
/// functions. For example, you can use this to count the base-10 digits of an integer:
///
///		let digits = 100 |> toString |> count // => 3
public func |> <T, U> (left: T, right: (T) -> U) -> U {
    return right(left)
}
