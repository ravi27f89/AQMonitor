//
//  ListVC.swift
//  AQMonitor
//

import UIKit
import RxSwift
import RxCocoa
// MARK: - 🚧 Development Status - ✅ Completed ✅
/// 📣`ListVC`
/// -  ` Usage ` : -- `Business Rules:`
/// -  At Initial request user will able to find 5 list of cities and later more cities to display Air Quality values.
///

class ListVC: UIViewController {
    
    // MARK: - 📣 Outlets
    /// Table view
    @IBOutlet var tableView: UITableView!
    
    // MARK: - 📣 Variables | Public - Private Properties
    private var viewModel: ListViewModel?
    
    private var bag = DisposeBag()
    
    // MARK: - ✅ View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.accessibilityIdentifier = "table--cityTableView"
        
        viewModel = ListViewModel(dataProvider: DataProvider())
        
        bindTableData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe to AQIs Socket Connection
        viewModel?.subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    // MARK: - ✅ Memory MGT
    deinit {
        // unsubscribe
        viewModel?.unsubscribe()
    }

    // MARK: - Bind Data from Delagete and display in tableview.

    func bindTableData() {
        
        // bind items to table
        viewModel?.items.bind(to: tableView.rx.items(cellIdentifier: "CityDataCell", cellType: CityDataCell.self)) {row, model, cell in
            
            cell.cityData = model
            
        }.disposed(by: bag)
        
        // bind a model selected handler
        tableView.rx.modelSelected(CityDataModelData.self).bind { item in
            
            let cityDetail: AQIGraphVC = self.storyboard?.instantiateViewController(identifier: "AQIGraphVC") as! AQIGraphVC
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)            
            
        }.disposed(by: bag)
        
        
        // set delegate
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
}
// MARK: - 🆗 UITableViewDataSource 🆗
extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}



