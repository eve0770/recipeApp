//
//  AddRecipeViewController.swift
//  Recipe
//
//  Created by Calvin Tan on 27/12/2016.
//  Copyright © 2016 Calvin Tan. All rights reserved.
//

import UIKit

protocol AddRecipeViewControllerProtocol
{
    // one protocol to cancel
//    func cancelAddingRecipe()
    
    // one protocol when successfully add
    func dismissViewController(newrecipe: newRecipe) // will be better if you rename this protocol
//    func newRecipeCreated(newRecipe: Recipe) // notice that I use Recipe class instead of newRecipe

}

class AddRecipeViewController: UIViewController {
    
    @IBOutlet weak var typedNameText: UITextField!
    @IBOutlet weak var typeTypeText: UITextField! {
        didSet {
            // set the delegate of this textfield and if it become the first responder you should display the category you got from xml file instead
            // or make a button which display the category instead of creating your own and entering the text
        }
    }
    
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
        // don't do this, if you have delegate use delegate
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButton(_ sender: UIBarButtonItem)
    {
        // don't use new as variable name
        let new = newRecipe()
        
        // becarefull with the force unwrap optional
        new.name = typedNameText.text!
        new.type = typeTypeText.text!
        new.description = typeDescText.text!
        new.picture = catchImage.image
        
        // don't dismiss itself
        // just tell your delegate and let delegate dismiss this view controller
        self.dismiss(animated: true, completion: {
            self.delegate?.dismissViewController(newrecipe: new)
        })
    }


}
