//
//  DetailViewController.swift
//  Recipe
//
//  Created by Calvin Tan on 27/12/2016.
//  Copyright © 2016 Calvin Tan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    // don't use this
    // use the model class that you created which is Recipe
    var name : String?
    var type : String?
    var desc : String?
    var headtitle : String?
    var foodpic : UIImage?
    
    
    // so you will have something like
    // var recipe : Recipe! // you put force unwrap here because this viewcontroller cannot exist without the recipe, you don't want to display empty recipe
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameText.text = name
        typeText.text = type
        descText.text = desc
        titleLabel.text = headtitle
        foodImage.image = foodpic
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem)
    {
        // please use delegate / protocol
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
