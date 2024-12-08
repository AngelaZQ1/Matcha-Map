//
//  CafeBottomSheetController.swift
//  Matcha Map
//
//  Created by Mathena Chan on 11/20/24.
//

import UIKit

class CafeBottomSheetController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let bottomSheetView = CafeBottomSheet()
    var cafes: [Place] = [] // Array of cafes to display
    let notificationCenter = NotificationCenter.default

    override func loadView() {
        view = bottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        bottomSheetView.tableView.dataSource = self
        bottomSheetView.tableView.delegate = self
        bottomSheetView.tableView.register(CafesTableViewCell.self, forCellReuseIdentifier: "cafes")
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cafes", for: indexPath) as? CafesTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: cafes[indexPath.row])
        return cell
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCafe = cafes[indexPath.row]
        
        // show the cafe screen
        notificationCenter.post(
            name: Notification.Name("viewCafe"),
            object: nil,
            userInfo: ["cafeName": selectedCafe.name])
        
        self.dismiss(animated: true)
    }
}

