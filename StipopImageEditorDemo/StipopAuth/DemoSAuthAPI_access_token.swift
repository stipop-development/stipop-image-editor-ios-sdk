//
//  DemoSAuthAPI_access_token.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/05.
//

import Alamofire

extension DemoSAuthAPI {
    
    static func getAccessToken(userId: String,
                               completion: ((String) -> Void)?,
                               failure: ((DemoSAuthError?) -> Void)? = nil) -> DataRequest {
        return request(Path.accessToken,
                       method: .post,
                       userId: userId,
                       completion: { response in
            completion?(response.body?.accessToken ?? "")
        }, failure: failure)
    }
}
