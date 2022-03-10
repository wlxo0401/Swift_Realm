//
//  ViewController.swift
//  Swift_Realm
//
//  Created by 김지태 on 2022/03/10.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    // 객체 생성
    let realm = try! Realm()
    // 불러온 데이터를 담을 객체
    var persons: Results<TestData>?
    
    // % 중요하지 않음 - 테이블 뷰에서 선택된 Row를 알기 위함
    var selectedRow: Int?

    // UI
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var personTableView: UITableView!
    @IBOutlet weak var selectedRowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        personTableView.dataSource = self
        personTableView.delegate = self
        
        // 시작하며 데이터를 확인한다.
        persons = realm.objects(TestData.self)
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let age = ageTextField.text else { return }
        
        // person 객체를 생성한다.
        let person = TestData(name: name, age: age)
        // realm에 입력한다.
        try! realm.write {
            realm.add(person)
        }
        
        // 테이블 재로드
        personTableView.reloadData()
    }
    
    @IBAction func deleteRowBtn(_ sender: Any) {
        if let row = selectedRow {
            if let toDelete = persons?[row] {
                try! realm.write {
                    realm.delete(toDelete)
                }
                selectedRow = nil
                selectedRowLabel.text = "선택된 Row : -"
            }
        } else {
            print("선택된 Row 없음.")
        }
        personTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = persons?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personTableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        if let  item = persons?[indexPath.row] {
            let name = item.name
            let age = item.age
            cell.nameLabel.text = name
            cell.ageLabel.text = age
        }
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedRowLabel.text = "선택된 Row :\(indexPath.row)"
        personTableView.deselectRow(at: indexPath, animated: true)
    }
}
