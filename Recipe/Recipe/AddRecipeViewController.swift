//
//  AddRecipeViewController.swift
//  Recipe
//
//  Created by Calvin Tan on 27/12/2016.
//  Copyright © 2016 Calvin Tan. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {
    @IBOutlet weak var typedNameText: UITextField!
    @IBOutlet weak var typeTypeText: UITextField!
    @IBOutlet weak var typeDescText: UITextView!
    @IBOutlet weak var catchImage: UIImageView!
    
    var delegate : AddRecipeViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButton(_ sender: UIBarButtonItem)
    {
        let new = newRecipe()
        new.name = typedNameText.text!
        new.type = typeTypeText.text!
        new.description = typeDescText.text!
        new.picture = catchImage.image
        self.dismiss(animated: true, completion: {
            self.delegate?.dismissViewController(newrecipe: new)
        })
    }


}
