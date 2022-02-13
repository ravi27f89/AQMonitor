//
//  AQIGraphVC.swift
//  AQMonitor
//

import UIKit
import RxSwift
import RxCocoa
import Charts
// MARK: - 🚧 Development Status - ✅ Completed ✅
/// 📣`AQIGraphVC`
/// -  ` Usage ` : -- `Business Rules:`
/// -  Detail graph representation for selected city.
///

class AQIGraphVC: UIViewController {
    
    // MARK: - 📣 Outlets
    /// Chart view
    @IBOutlet weak var chartView: LineChartView!
    
    // MARK: - 📣 Variables | Public - Private Properties
    var cityModel: CityDataModelData = CityDataModelData(city: "")
    private var viewModel: DetailViewModel?
    private var bag = DisposeBag()
    var dataEntries = [ChartDataEntry]()
    var xValue: Double = 30

    // MARK: - ✅ View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel(dataProvider: DataProvider())
        self.title = cityModel.city
        setupInitialDataEntries()
        setupChartData()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe
        viewModel?.subscribe(forCity: cityModel.city)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unsubscribe
        viewModel?.unsubscribe()
    }
    
    // MARK: - Bind Data on chartview for graph reprentation.
    func bindData() {
     
        viewModel?.item.bind { model in
        
            if let v = model.history.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
                
        }.disposed(by: bag)
    }
}

// MARK: - Graph method

extension AQIGraphVC {
    
    func setupInitialDataEntries() {
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    func setupChartData() {
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "AQI for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = false
        chartDataSet.setColor(.systemBlue)
        chartDataSet.mode = .linear

        if let font = UIFont(name: "TrebuchetMS", size: 10) {
            chartDataSet.valueFont = font
        }

        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }

        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)
            
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
    
}
