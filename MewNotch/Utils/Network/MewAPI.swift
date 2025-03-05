//
//  MewAPI.swift
//  MewNotch
//
//  Created by Monu Kumar on 05/03/2025.
//

import Foundation

class MewAPI {
    
    static let shared = MewAPI()
    
    private init() { }
    
    func getLatestRelease(
        onComplete: @escaping (MewReleaseAPIResponseModel?) -> Void
    ) {
        let _: [MewReleaseAPIResponseModel]? = APIService.shared.get(
            url: .init(
                string: "https://api.github.com/repos/monuk7735/mew-notch/releases"
            )
        ) { result in
            if case .success(let releases) = result {
                if let latestRelease = releases.filter({
                    $0.publishedAt != nil
                }).max(
                    by: {
                        $0.publishedAt! < $1.publishedAt!
                    }
                ) {
                    onComplete(
                        latestRelease
                    )
                    
                    return
                }
            }
            
            onComplete(
                nil
            )
        }
    }
    
}
