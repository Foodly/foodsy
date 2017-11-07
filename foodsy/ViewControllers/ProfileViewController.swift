//
//  ProfileViewController.swift
//  foodsy
//
//  Created by hsherchan on 10/10/17.
//  Copyright © 2017 Foodly. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var totalShoppingLabel: UILabel!
    

    @IBOutlet weak var favoritesBtn: UIButton!
    @IBOutlet weak var collectionsBtn: UIButton!
    @IBOutlet weak var totalIngredientsLabel: UILabel!
    @IBOutlet weak var totalFavoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var selfRecipeImagesCollection: [SelfRecipeImage]?
    var favoriteRecipes: [Recipe]?
    var showCollections = true
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        nameLabel.text = user?.name
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        profileImageView.setImageWith((user?.profileUrl)!)
        
        collectionsBtn.layer.cornerRadius = 5;
        favoritesBtn.layer.cornerRadius = 5;
        
        collectionsBtn.tag = 0
        favoritesBtn.tag = 1
        
        self.totalIngredientsLabel.text = "0"
        self.totalShoppingLabel.text = "0"
        self.totalFavoritesLabel.text = "0"
        
        collectionsBtn.addTarget(self, action: #selector(onChoose(_:)), for: .touchUpInside)
        favoritesBtn.addTarget(self, action: #selector(onChoose(_:)), for: .touchUpInside)
        
        
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = 173;
        tableView.rowHeight = UITableViewAutomaticDimension
        let selfRecipeCell = UINib(nibName: "SelfRecipeImageTableViewCell", bundle: nil)
        tableView.register(selfRecipeCell, forCellReuseIdentifier: "SelfRecipeCell")
        let recipeCellNib = UINib(nibName: "RecipeCell", bundle: nil)
        tableView.register(recipeCellNib, forCellReuseIdentifier: "RecipeCell")
        SelfRecipeImage.fetchAllForUser(name: (User.currentUser?.screenname)!) { (selfRecipes) in
            self.selfRecipeImagesCollection = selfRecipes
            self.tableView.reloadData()
        }
        collectionsBtn.titleLabel?.addTextSpacing(spacing: 1.2)
        favoritesBtn.titleLabel?.addTextSpacing(spacing: 1.2)
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateLabels()
        updateBtnBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    @objc func onChoose(_ sender: UIButton) {
        if sender.tag == 0 {
            if !showCollections {
                showCollections = true
                updateBtnBackgroundColor()
                SelfRecipeImage.fetchAllForUser(name: (User.currentUser?.screenname)!) { (selfRecipes) in
                    self.selfRecipeImagesCollection = selfRecipes
                    self.tableView.reloadData()
                }
            }
        } else if sender.tag == 1 {
            if showCollections {
                showCollections = false
                updateBtnBackgroundColor()
                Recipe.fetchFavoriteRecipesForUser(name: (User.currentUser?.screenname)!) { (recipes) in
                    self.favoriteRecipes = recipes;
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func updateBtnBackgroundColor() {
        if showCollections {
            collectionsBtn.backgroundColor = Utils.getPrimaryColor()
            collectionsBtn.setTitleColor(.white, for: .normal)
            collectionsBtn.setTitleColor(.white, for: .selected)
            favoritesBtn.backgroundColor = Utils.getDisabledButtonColor()
            favoritesBtn.setTitleColor(Utils.getDisabledButtonTextColor(), for: .normal)
        } else {
            favoritesBtn.backgroundColor = Utils.getPrimaryColor()
            favoritesBtn.setTitleColor(.white, for: .normal)
            favoritesBtn.setTitleColor(.white, for: .selected)
            collectionsBtn.backgroundColor =  Utils.getDisabledButtonColor()
            collectionsBtn.titleLabel?.textColor = Utils.getDisabledButtonTextColor()
            collectionsBtn.setTitleColor(Utils.getDisabledButtonTextColor(), for: .normal)
        }
    }
    
    func updateLabels() {
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!, type: "shopping") { (shopping) in
            if let shopping = shopping {
                self.totalShoppingLabel.text = "\(shopping.count)"
            }
            
        }
        Ingredient.fetchIngredientsForUser(name: (User.currentUser?.screenname)!, type: "ingredient") { (ingredient) in
            if let ingredient = ingredient {
                self.totalIngredientsLabel.text = "\(ingredient.count)"
            }
            
        }
        Recipe.fetchFavoriteRecipesForUser(name: (User.currentUser?.screenname)!) { (recipes) in
            if let recipes = recipes {
                self.totalFavoritesLabel.text = "\(recipes.count)"
            }
            
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showCollections {
            if let recipeImagesCollection = selfRecipeImagesCollection {
                return recipeImagesCollection.count
            } else {
                return 0
            }
        } else {
            if let favoriteRecipes = favoriteRecipes {
                return favoriteRecipes.count
            } else {
                return 0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showCollections {
            if let recipeImagesCollection = selfRecipeImagesCollection {
                if ( recipeImagesCollection.count > 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SelfRecipeCell", for: indexPath) as! SelfRecipeImageTableViewCell
                    
                    let selfRecipeImage = selfRecipeImagesCollection?[indexPath.row]
                    cell.recipeTitleLabel.text = selfRecipeImage?.title
                    
                    
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(truncating: (selfRecipeImage?.date)!))
                    
                    // US English Locale (en_US)
                    let dateString = dateFormatter.string(from: date) // Jan 2, 2001
                    cell.createdLabel.text = "BEAUTIFULLY CREATED ON \(dateString.uppercased())"
                    cell.createdLabel.addTextSpacing(spacing: 1.2)
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(tapGestureRecognizer:)))
                    selfRecipeImage?.getImage(index: 0, success: { (image) in
                        if let image = image {
                            cell.recipeImageView.image = image
                            cell.recipeImageView.isUserInteractionEnabled = true
                            cell.recipeImageView.addGestureRecognizer(tapGestureRecognizer)
                        } else {
                            cell.recipeImageView.isUserInteractionEnabled = false
                        }
                    }, failure: { (error) in
                        print("error")
                    })
                    
                    selfRecipeImage?.getImage(index: 1, success: { (image) in
                        if let image = image {
                            cell.recipeImageView1.image = image
                            cell.recipeImageView1.isUserInteractionEnabled = true
                            cell.recipeImageView1.addGestureRecognizer(tapGestureRecognizer)
                        } else {
                            cell.recipeImageView1.isUserInteractionEnabled = false
                        }
                    }, failure: { (error) in
                        print("error")
                    })
                    
                    selfRecipeImage?.getImage(index: 2, success: { (image) in
                        if let image = image {
                            cell.recipeImageView2.image = image
                            cell.recipeImageView2.isUserInteractionEnabled = true
                            cell.recipeImageView2.addGestureRecognizer(tapGestureRecognizer)
                        } else {
                            cell.recipeImageView2.isUserInteractionEnabled = false
                        }
                    }, failure: { (error) in
                        print("error")
                    })
                    
                    let backgroundView = UIView()
                    backgroundView.backgroundColor = Utils.getTransparentWhiteColor()
                    cell.selectedBackgroundView = backgroundView
                    return cell
                }
            }
        } else {
            if let favoriteRecipes = favoriteRecipes {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
                let recipe = favoriteRecipes[indexPath.row]
                cell.recipe = recipe
                cell.backgroundColor = UIColor.clear
                let image = UIImage(named: "heart-filled") as UIImage!
                cell.favoriteBtn.setBackgroundImage(image, for: UIControlState.normal)
                cell.delegate = self;
                
                let backgroundView = UIView()
                backgroundView.backgroundColor = Utils.getTransparentWhiteColor()
                cell.selectedBackgroundView = backgroundView
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showCollections {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelfRecipeCell", for: indexPath) as! SelfRecipeImageTableViewCell
            let selectedRecipe = favoriteRecipes?[indexPath.row]
            let storyboard = UIStoryboard(name: "Recipe", bundle: nil)
            let recipeDetailsViewController = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsViewController") as! RecipeDetailsViewController
            recipeDetailsViewController.recipe = selectedRecipe
            recipeDetailsViewController.navigationItem.leftBarButtonItem?.tintColor = .white
            let navController = UINavigationController(rootViewController: recipeDetailsViewController)
            navController.childViewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< RECIPES", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack(_:)))
            navController.navigationBar.isTranslucent = false
            tableView.deselectRow(at: indexPath, animated: true)
            self.show(navController, sender: self)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let storyboard = UIStoryboard(name: "PhotoView", bundle: nil)
        let photoViewNavigationController = storyboard.instantiateViewController(withIdentifier: "PhotoViewNavigationController") as! UINavigationController
        let photoViewController = photoViewNavigationController.topViewController as! PhotoViewController
        photoViewController.image = tappedImage.image
        self.show(photoViewNavigationController, sender: self)
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: FavoriteCellDelegate {
    func favoriteCell(favoriteRecipeCell: RecipeCell) {
        if !showCollections {
            let indexPath = tableView.indexPath(for: favoriteRecipeCell)!
            let recipe = favoriteRecipes![indexPath.row]
            recipe.unfavoriteForUser()
            favoriteRecipes?.remove(at: indexPath.row)
            let favoritesCount = (favoriteRecipes?.count)!
            totalFavoritesLabel.text = "\(favoritesCount)"
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
        
    }
}
