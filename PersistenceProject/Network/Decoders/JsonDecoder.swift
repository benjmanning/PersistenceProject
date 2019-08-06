//
//  JsonDecoder.swift
//  PersistenceProject
//
//  Created by Ben Manning on 30/06/2019.
//  Copyright © 2019 Ben Manning. All rights reserved.
//

import UIKit

struct JsonDecoder: APIResponseDecoder {
  func decode<Decoded: Decodable>(data: Data) throws -> Decoded {
    return try JSONDecoder().decode(Decoded.self, from: data)
  }
}
