//
//  SectionModel.swift
//  Assignment
//
//  Created by 경원이 on 2023/07/01.
//

import Foundation

import RxDataSources

struct CarListSectionModel {
  var header: String
  var items: [Item]
}
extension CarListSectionModel: SectionModelType {
  typealias Item = Car

   init(original: CarListSectionModel, items: [Item]) {
    self = original
    self.items = items
  }
}
