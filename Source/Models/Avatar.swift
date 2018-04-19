//
//  Avatar.swift
//  OmiseGO
//
//  Created by Mederic Petit on 18/4/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an avatar containing urls of different sizes
public struct Avatar: Decodable {

    /// The url of the original image
    public let original: String
    /// The url of the large image
    public let large: String
    /// The url of the small image
    public let small: String
    /// The url of the thumbnail image
    public let thumb: String

}
