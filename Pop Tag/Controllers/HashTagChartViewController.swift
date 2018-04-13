//
//  HashTagChartViewController.swift
//  Pop Tag
//
//  Created by Kaichi Momose on 2018/04/12.
//  Copyright © 2018 Kaichi Momose. All rights reserved.
//

import UIKit

class HashTagChartViewController: UIViewController {
    
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var currentHashtagPostLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chartButton.imageView?.image = UIImage(named: "chart")?.withRenderingMode(.alwaysTemplate)
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HashTagChartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableHeader")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath) as! ChartTableViewCell
        cell.hashTagLabel.text = "#developer"
        cell.emojiLabel.text = "🔥"
        cell.postLabel.text = "2.0"
        return cell
    }
}
