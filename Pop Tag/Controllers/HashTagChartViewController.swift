//
//  HashTagChartViewController.swift
//  Pop Tag
//
//  Created by Kaichi Momose on 2018/04/12.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class HashTagChartViewController: UIViewController, AlertPresentable {
    
    //MARK: Propaties
//    private var aaChartModel: AAChartModel!
    private var aaChartType: AAChartType!
    private var aaChartView: AAChartView!
    
    private var currentDay: String!
    private var time: String!
    private var selectedHashTag: Int!
    private var datas = [[String:[Double]]]()
    
    private let hashTags = ["developer", "webdeveloper", "webdevelopment", "webdesigner", "programmer", "programming", "mobilephoto", "mobileartistry"]
    private let times: [String] = ["0am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm"]
    private let days: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    //MARK: - Outlets
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var currentHashtag: UILabel!
    @IBOutlet weak var currentHashtagPostLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aaChartView = AAChartView()
        self.chartView.addSubview(aaChartView!)
        
        self.chartView.bringSubview(toFront: activeIndicator)
        self.activeIndicator.startAnimating()
        
        let chartType = UserDefaults.standard.string(forKey: "ChartType")
        if let userChartType = chartType {
            if userChartType == "line" {
                aaChartType = AAChartType.Line
            } else if userChartType == "column"{
                aaChartType = AAChartType.Column
            } else {
                aaChartType = AAChartType.Spline
            }
//            aaChartType = userChartType as! AAChartType
        } else {
            aaChartType = AAChartType.Line
        }
        
        self.selectedHashTag = 0
        self.currentHashtag.text = "#" + hashTags[self.selectedHashTag]
        
        for hashTag in hashTags {
            let readCSV = ReadCSV(fileName: hashTag)
            datas.append(readCSV.createDictionaryGrouthRate())
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setDayAndTime()
        self.setLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //set aaChartView Constrains
        aaChartView?.frame = chartView.frame
        self.loadChart()
        self.activeIndicator.stopAnimating()
        self.chartView.sendSubview(toBack: self.activeIndicator)
    }

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        
        return refreshControl
    }()
    
    @objc func handleRefresh() {
        setDayAndTime()
        self.refreshControl.endRefreshing()
    }
    
    func setDayAndTime() {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        //get localized day of week
        formatter.dateFormat = "EEEE"
        self.currentDay = formatter.string(from: currentDateTime)
        self.dayLabel.text = currentDay
        //get localized time
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        let currentTime: String = formatter.string(from: currentDateTime)
        var hour = String(currentTime.prefix(2))
        if let i = hour.index(of: ":") {
            hour.remove(at: i)
        }
        self.time = hour + String(currentTime.suffix(2)).lowercased()
        //next one hour
        var nextHourIndex = self.times.index(of: self.time)! + 1
        if nextHourIndex == self.times.count {
            nextHourIndex = 0
        }
        let nextHour = self.times[nextHourIndex]
        
        self.timeLabel.text = self.time + "-" + nextHour
    }
    
    func loadChart() {
        let aaChartModel = AAChartModel.init()
            .chartType(self.aaChartType)//图形类型
            .colorsTheme(["#9b43b4","#ef476f","#ffd066","#04d69f","#25547c",])//主题颜色数组
            .title("")
            .subtitle("")/
            .dataLabelEnabled(false)
            .tooltipValueSuffix("posts/min")
            .categories(self.times)
            .xAxisVisible(true)
            .yAxisVisible(true)
            .series([
                AASeriesElement()
                    .name(self.currentDay)
                    .data(self.datas[self.selectedHashTag][self.currentDay]!)
                    .toDic()!,
                ])
        
        aaChartView.aa_drawChartWithChartModel(aaChartModel)
    }
    
    func setLabels() {
        self.currentHashtag.text = "#" + hashTags[self.selectedHashTag]
        let post = datas[self.selectedHashTag][self.currentDay]?[self.times.index(of: self.time)!]
        self.currentHashtagPostLabel.text = String(format:"%.2f", post!)
    }
    
    func lineChartSlected() {
        UserDefaults.standard.set("line", forKey: "ChartType")
        self.aaChartType = AAChartType.Line
        self.loadChart()
    }
    
    func columnChartSlected() {
        UserDefaults.standard.set("column", forKey: "ChartType")
        self.aaChartType = AAChartType.Column
        self.loadChart()
    }
    
    func splineChartSlected() {
        UserDefaults.standard.set("spline", forKey: "ChartType")
        self.aaChartType = AAChartType.Spline
        self.loadChart()
    }
    
    @IBAction func chartButtonTapped(_ sender: Any) {
        selectChartType(line: lineChartSlected, column: columnChartSlected, spline: splineChartSlected)
    }
    
}

extension HashTagChartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableHeader")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath) as! ChartTableViewCell
        let row = indexPath.row
        cell.hashTagLabel.text = "#" + hashTags[row]
        cell.emojiLabel.text = ""
        let post = datas[row][self.currentDay]?[self.times.index(of: self.time)!]
        cell.postLabel.text = String(format:"%.2f", post!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedHashTag != indexPath.row {
            self.selectedHashTag = indexPath.row
            self.setLabels()
            self.loadChart()
        }
    }
    
    
}
