//
//  Alamofire+Codable.swift
//  Codable
//
//  Created by sodas on 6/6/17.
//  Copyright © 2017 sodastsai. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.DataRequest {

    @discardableResult public
    func responseJSONCodable<Model: Codable>(queue: DispatchQueue? = nil,
                                             configurationHandler: ((JSONDecoder) -> Void)? = nil,
                                             completionHandler: @escaping (DataResponse<Model>) -> Void) -> Self {
        // Decoder setup
        let decoder = JSONDecoder()
        configurationHandler?(decoder)
        // Response serializer setup
        let serializer = DataResponseSerializer { (_, _, data, error) -> Result<Model> in
            guard error == nil else { return .failure(error!) }
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            do {
                let model = try decoder.decode(Model.self, from: validData)
                return .success(model)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
        // Go!
        return self.response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }
}
