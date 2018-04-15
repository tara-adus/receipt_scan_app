
//
//  ViewController.swift
//  TextRecognition
//
//  Created by Tara on 3/17/18.
//  Copyright © 2018 Tara. All rights reserved.
//
import UIKit
import TesseractOCR
import Charts

class ViewController: UIViewController, G8TesseractDelegate, ChartViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pieChart: PieChartView!
    
    var grainsDataEntry = PieChartDataEntry(value: 0)
    var fruitDataEntry = PieChartDataEntry(value: 0)
    var dairyDataEntry = PieChartDataEntry(value: 0)
    var vegetablesDataEntry = PieChartDataEntry(value: 0)
    var junkDataEntry = PieChartDataEntry(value: 0)
    var proteinDataEntry = PieChartDataEntry(value: 0)
    
    var allFoods = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.black.cgColor
        
        pieChart.chartDescription?.text = "food categories"
        
        grainsDataEntry.label = "grain"
        fruitDataEntry.label = "fruit"
        dairyDataEntry.label = "dairy"
        vegetablesDataEntry.label = "vegetables"
        junkDataEntry.label = "junk"
        proteinDataEntry.label = "protein"
        
        if let tesseract = G8Tesseract(language: "eng"){
            tesseract.delegate = self
            tesseract.image = UIImage(named: "traderjoes")?.g8_blackAndWhite()
            tesseract.recognize()
            
            textView.text = tesseract.recognizedText
            
            let myStringArr = textView.text.components(separatedBy: "\n");
            let userinfo = ["grains": ["barley" , "bread" , "cereal" , "cornmeal" , "grits" , "oat" , "oats" , "pasta" , "refined grains" , "rice" , "wheat", "whole grain"], "fruits": ["lemon", "mango", "orange", "papaya", "peach", "pear", "pineapple", "pomogranate", "pumpkin", "rasberries", "strawberry", "tomatoe", "watermelon"], "dairy":["butter", "cheese" , "milk" , "yogurt"], "vegetables": ["artichoke", "arugula", "asparagus", "beets","bok choy", "broccoli", "brussel sprouts", "cabbage", "carrots", "cauliflower", "celery", "collard", "corn", "cucumber", "edamame", "eggplant", "fennel", "ginger root","green bean", "kale", "leeks", "lettuce", "mushroom", "mustard greens", "okra","onions", "parsnip", "peas", "pepper", "potato", "raddish","shallots", "spinach", "turnip","zucchini"], "protein":["almond","anchovies","bacon", "beans","steak","chicken","fish", "nuts","meat", "crab", "egg","hummus", "lamb", "lobster", "pork","prawns", "seeds", "salmon", "sardines", "sausages", "tofu", "turkey"], "junks":["french fries","fried chicken","fried", "soda", "pizza", "hamburger","hot dog","taco","chicken nuggets", "nachos", "custard", "pudding","cake","pie", "flan", "sorbet", "chocolate", "brownie", "sundae", "tirmisue", "trifle", "meringue", "baked alaska", "waffle", "pancake", "baklava", "panna cotta", "gelato", "turnover","gulab jamun", "tooti frotti", "jalebi","pastry", "tart","ice cream"]]
            var graincount = 0
            var totalcount = 0
            var fruitcount = 0
            var vegetablescount = 0
            var dairycount = 0
            var junkcount = 0
            var proteincount = 0
            
            for line in myStringArr
            {
                totalcount += 1
                print(line)
                
                
                for (key, values) in userinfo
                {
                    for item in values
                    {
                        
                        
                        if line.lowercased().range(of:item.lowercased()) != nil {
                            
                            print("found")
                            print("The key: \(key)")
                            switch key
                            {
                            case "grains":
                                graincount += 1
                            case "fruits":
                                fruitcount += 1
                            case "veggies":
                                vegetablescount += 1
                            case "dairy":
                                dairycount +=  1
                            case "protein":
                                proteincount += 1
                            case "junk":
                                junkcount += 1
                                break
                            default:
                                break
                            }
                            break
                        }
                    }
                }
                
            }
            let grainspercent = (Double)(graincount)/(Double)(totalcount) * 100
            print("Grains Percent: \(grainspercent)")
            grainsDataEntry.value = grainspercent
            
            let fruitspercent = (Double)(fruitcount)/(Double)(totalcount) * 100
            print("Fruits Percent: \(fruitspercent)")
            fruitDataEntry.value = fruitspercent
            
            let vegetablespercent = (Double)(vegetablescount)/(Double)(totalcount)*100
            print("Vegetables Percent: \(vegetablespercent)")
            vegetablesDataEntry.value = vegetablespercent
            
            let proteinspercent = (Double)(proteincount)/(Double)(totalcount) * 100
            print(proteinspercent)
            proteinDataEntry.value = proteinspercent
            
            let junkspercent = (Double)(junkcount)/(Double)(totalcount) * 100
            print("Junks Percent: \(junkspercent)")
            junkDataEntry.value = junkspercent
            
            let dairypercent = (Double)(dairycount)/(Double)(totalcount) * 100
            print("Dairy Percent:\(dairypercent)")
            dairyDataEntry.value = dairypercent
        }
        
        allFoods = [grainsDataEntry, fruitDataEntry, dairyDataEntry, vegetablesDataEntry, junkDataEntry, proteinDataEntry]
        
        updatePieChartData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePieChartData(){
        print("===allFoods")
        print(allFoods)
    
        let chartDataSet = PieChartDataSet(values: allFoods, label: "foods")
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.black, UIColor.purple, UIColor.brown]
        chartDataSet.colors = colors
        pieChart.data = chartData
    }
}



