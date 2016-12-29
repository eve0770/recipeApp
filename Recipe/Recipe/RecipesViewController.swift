//
//  ViewController.swift
//  Recipe
//
//  Created by Calvin Tan on 27/12/2016.
//  Copyright © 2016 Calvin Tan. All rights reserved.
//

import UIKit


// remember i remind you guys to use extension when implementing protocol/delegate/datasource??
class RecipesViewController: UIViewController, XMLParserDelegate, AddRecipeViewControllerProtocol {

    @IBOutlet weak var tableView: UITableView!
    {
        didSet
        {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var pickerView: UIPickerView!
    {
        didSet{
            pickerView.dataSource = self
            pickerView.delegate = self
        }
    }

    var recipes = [newRecipe]()
    var filterRecipes = [newRecipe]()
    var categories = [String]()
    var holdCategories : String = ""
    var recipeType = String()
    var eName = String()
    var selectedRow = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        categories.append("All")
        parseXML() // will be better if you create a separate class for XMLParser and let that class handle all the parsing
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // This whole chunk is better separated into extension or as mentioned above use separate class to handle the parser
    // start here ---
    func parseXML()
    {
                if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml")
        {
            if let parser = XMLParser(contentsOf: path)
            {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName
        if elementName == "recipetype"
        {
            recipeType = String() // this not eaxctly needed unless you create a new node
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "recipetype"
        {
            let recipe = Recipe()
            recipe.recipeType = recipeType
            categories.append(recipeType)
        }
        tableView.reloadData() // you don't need to reload tableview here
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (!data.isEmpty)
        {
            if eName == "name"
            {
                recipeType += data
            }
        }
        
        tableView.reloadData() // you don't need to reload tableview here too
    }
    // --- until here
    
    


    @IBAction func sortButton(_ sender: UIBarButtonItem)
    {
        if pickerView.isHidden == true
        {
            sender.title = "Done"
            pickerView.isHidden = false
            pickerView.backgroundColor = UIColor.lightGray
        }
        else
        {
            sender.title = "Sort"
            pickerView.isHidden = true
        }
    }
    

    @IBAction func newButton(_ sender: UIBarButtonItem)
    {
        let avc = self.storyboard?.instantiateViewController(withIdentifier: "AddRecipe") as! AddRecipeViewController
        avc.delegate = self
        self.present(avc, animated: true, completion: nil)
    }
    
    func dismissViewController(newrecipe: newRecipe)
    {
        
        
        self.dismiss(animated: false, completion: {() -> Void in
            
            // why did you need to instantiate again? you just need to dismiss it
            // from this --
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Recipes") as! RecipesViewController
            self.present(vc, animated: true, completion: nil)
            // until this --
            // not required
            
            
        })
        
        // this should be inside the closure instead ^
        recipes.append(newrecipe)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue"
        {
            let destination = segue.destination as! DetailViewController
            if filterRecipes.count == 0 || (holdCategories == "All")
            {
                let selectedFood = recipes[selectedRow]
                destination.name = selectedFood.name
                destination.type = selectedFood.type
                destination.desc = selectedFood.description
                destination.headtitle = selectedFood.name
                destination.foodpic = selectedFood.picture
            }
            else
            {
                let selectedFood = filterRecipes[selectedRow]
                destination.name = selectedFood.name
                destination.type = selectedFood.type
                destination.desc = selectedFood.description
                destination.headtitle = selectedFood.name
                destination.foodpic = selectedFood.picture

            }

        }
    }

}

extension RecipesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterRecipes.count == 0 || (holdCategories == "All")
        {
            return recipes.count
        }
        else
        {
            return filterRecipes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let food : newRecipe
        if filterRecipes.count == 0 || (holdCategories == "All")
        {
            food = recipes[indexPath.row]
        }
        else
        {
            food = filterRecipes[indexPath.row]
        }
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = food.type
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // why did you need to count the recipe == 0?
        
        if filterRecipes.count == 0
        {
            recipes.remove(at: indexPath.row)
        }
        else
        {
            // you don't need to do this
            // simply filter your array data source and reloadData of your table view
            let object = filterRecipes[indexPath.row]
            recipes = recipes.filter{$0.name != object.name}
            filterRecipes.remove(at: indexPath.row)
        }
        tableView.reloadData()
        
        // on editing what you should check is the editing style
        // ex:
        switch editingStyle {
        case .delete: break // create a function to handle deletion
        case .insert: break// create a function to handle insertion
        default: break
            // do something here
        }
    }
}

extension RecipesViewController: UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
}

extension RecipesViewController: UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        holdCategories = categories[row]
        filterRecipes = recipes.filter({($0.type?.contains("\(holdCategories)"))!})
        tableView.reloadData()
    }
}
