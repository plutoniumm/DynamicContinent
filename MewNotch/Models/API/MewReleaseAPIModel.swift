//
//  MewReleaseAPIModel.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/03/2025.
//

import Foundation

struct MewReleaseAPIResponseModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        var stringValue: String {
            self.rawValue
        }
        
        case url
        case tagName = "tag_name"
        case publishedAt = "published_at"
        case assets
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )
        
        self.url = try container
            .decode(
                String.self,
                forKey: .url
            )
        
        self.tagName = try container
            .decode(
                String.self,
                forKey: .tagName
            )
        
        let publishedDate = try container
            .decode(
                String.self,
                forKey: .publishedAt
            )
        
        self.publishedAt = ISO8601DateFormatter().date(
            from: publishedDate
        )
        
        self.assets = try container
            .decode(
                [MewReleaseAPIResponseModel.Asset].self,
                forKey: .assets
            )
    }
    
    let url: String
    
    let tagName: String
    let publishedAt: Date?
    
    let assets: [Asset]
    
    struct Asset: Codable {
        
        enum CodingKeys: String, CodingKey {
            
            var stringValue: String {
                self.rawValue
            }
            
            case name
            case browserDownloadUrl = "browser_download_url"
        }
        
        init(
            from decoder: any Decoder
        ) throws {
            let container: KeyedDecodingContainer<MewReleaseAPIResponseModel.Asset.CodingKeys> = try decoder.container(
                keyedBy: CodingKeys.self
            )
            
            self.name = try container.decode(
                String.self,
                forKey: .name
            )
            
            self.browserDownloadUrl = try container.decode(
                String.self,
                forKey: .browserDownloadUrl
            )
        }
        
        let name: String
        let browserDownloadUrl: String
    }
}
