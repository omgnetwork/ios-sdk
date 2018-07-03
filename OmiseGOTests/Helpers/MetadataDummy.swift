//
//  MetadataDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import UIKit

struct MetadataDummy: Decodable, APIParameters {
    let metadata: [String: Any]?
    let metadataArray: [Any]?
    let optionalMetadata: [String: Any]?
    let optionalMetadataArray: [Any]?
    let unavailableMetadata: [String: Any]?
    let unavailableMetadataArray: [Any]?

    private enum CodingKeys: String, CodingKey {
        case metadata
        case metadataArray = "metadata_array"

        // Used to test the `decodeIfPresent()` func
        case optionalMetadata = "optional_metadata"
        case optionalMetadataArray = "optional_metadata_array"
        case unavailableMetadata
        case unavailableMetadataArray
    }

    init(metadata: [String: Any]?,
         metadataArray: [Any]?,
         optionalMetadata: [String: Any]?,
         optionalMetadataArray: [Any]?,
         unavailableMetadata: [String: Any]?,
         unavailableMetadataArray: [Any]?) {
        self.metadata = metadata
        self.metadataArray = metadataArray
        self.optionalMetadata = optionalMetadata
        self.optionalMetadataArray = optionalMetadataArray
        self.unavailableMetadata = unavailableMetadata
        self.unavailableMetadataArray = unavailableMetadataArray
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do { self.metadata = try container.decode([String: Any].self, forKey: .metadata) } catch { self.metadata = [:] }
        do {
            self.metadataArray = try container.decode([Any].self, forKey: .metadataArray)
        } catch { self.metadataArray = nil }
        do {
            self.optionalMetadata = try container.decodeIfPresent([String: Any].self, forKey: .optionalMetadata)

        } catch { self.optionalMetadata = nil }
        do {
            self.optionalMetadataArray = try container.decodeIfPresent([Any].self, forKey: .optionalMetadataArray)

        } catch { self.optionalMetadataArray = nil }
        do {
            self.unavailableMetadata = try container.decodeIfPresent([String: Any].self, forKey: .unavailableMetadata)

        } catch { self.unavailableMetadata = nil }
        do {
            self.unavailableMetadataArray = try container.decodeIfPresent([Any].self, forKey: .unavailableMetadataArray)
        } catch { self.unavailableMetadataArray = nil }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(metadata ?? [:], forKey: .metadata)
        try container.encode(metadataArray ?? [], forKey: .metadataArray)
        try container.encodeIfPresent(optionalMetadata, forKey: .optionalMetadata)
        try container.encodeIfPresent(optionalMetadataArray, forKey: .optionalMetadataArray)
        try container.encodeIfPresent(unavailableMetadata, forKey: .unavailableMetadata)
        try container.encodeIfPresent(unavailableMetadataArray, forKey: .unavailableMetadataArray)
    }
}
