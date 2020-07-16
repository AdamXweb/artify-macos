//
//  Models+RxSwift.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/20/18.
//  Copyright © 2018 com.art.Desktopaint.core. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import Unbox

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    func mapToModel<T: Unboxable>(type: T.Type) -> Single<T> {
        return self
            .mapJSON()
            .flatMap({ (data) -> Single<T> in
                guard let data = data as? [String: Any] else {
                    throw DesktopaintError.serializeError(type)
                }
                let apiResponse: APIResponse<T> = try unbox(dictionary: data)
                return .just(apiResponse.data)
            })
            .do(onError: { (error) in
                print("[ERROR] mapToModel = \(error)")
            })
    }
}
