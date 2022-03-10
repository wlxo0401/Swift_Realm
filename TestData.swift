//
//  TestData.swift
//  Swift_Realm
//
//  Created by 김지태 on 2022/03/10.
//
import RealmSwift

class TestData: Object {
    @Persisted var name: String = ""
    @Persisted var age: String = ""

    convenience init(name: String, age: String) {
        self.init()
        self.name = name
        self.age = age
    }
}
