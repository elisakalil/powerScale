//
//  TableViewController.swift
//  powerScale
//
//  Created by Elisa Kalil on 03/05/22.
//

import Foundation
import UIKit

class TableViewController: UIViewController {
    
    private let residentialType: String
    private let appliances: [HomeApplianceModel]
    private var totalSelectedPower: Int = 0
    private var cellIdentifier = "defaultCell"

        
    private lazy var optionsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 90
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        table.dataSource = self
        return table
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.isSelected = false
        button.setTitle("Enviar", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .greenIFSC
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(pushFoward), for: .touchUpInside)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildHierarchyandLayout()
        setupConstraints()
        setupNavigation()
        presentModal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        totalSelectedPower = 0
    }
    
    init(appliances: [HomeApplianceModel], residentialType: String, nibName: String?, bundle: Bundle?) {
        self.appliances = appliances
        self.residentialType = residentialType
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentModal() {
        let presentModal = ModalViewController()
        if let alertController = presentModal.presentationController as? UISheetPresentationController {
            alertController.detents = [.medium()]
        }
        self.present(presentModal, animated: true)
    }
    
    @objc private func pushFoward(button: UIButton) {
        button.isSelected = true
        button.setTitleColor(.black, for: .selected)
        countTotalPower()
        self.navigationController?.pushViewController(FinalViewController(appliances: appliances, totalSelectedPower: totalSelectedPower, residentialType: residentialType, nibName: nil, bundle: nil), animated: true)
    }
    
    func buildHierarchyandLayout() {
        view.backgroundColor = .softRoseIFSC
        view.addSubview(optionsTableView)
        view.addSubview(sendButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            optionsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            
            sendButton.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 20),
            sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            sendButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
        func countTotalPower() {
            var totalKW = 0
            var totalPower = 0
            
            for item in appliances {
                
                if item.quantity > 0  && totalSelectedPower == 0 {
                    totalKW = (item.quantity) * (item.power)
                    totalPower += totalKW
                }
            }
            totalSelectedPower += totalPower
        }
    
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appliances.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell
        cell?.appliance = appliances[indexPath.row]
        return cell ?? UITableViewCell()
    }
}
