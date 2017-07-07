//
//  SpellViewController.swift
//  Book of Many Things
//
//  Created by Victor Jifcu on 2017-06-08.
//  Copyright © 2017 Victor Jifcu. All rights reserved.
//

import UIKit

class SpellViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var areaOfEffectLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var castingTimeLabel: UILabel!
    @IBOutlet weak var savingThrowLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var componentsLabel: UILabel!
    @IBOutlet weak var descriptionEndLabel: UILabel!
    @IBOutlet weak var textStackView: UIStackView!
    
    var nameLabel: UILabel!

    @IBOutlet weak var stackView: UIStackView!
    
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var numTables = 0
    
    var tableData = [[String]]()
    var tables = [UICollectionView]()

    var spell: Spell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel = UILabel()
        nameLabel.text = "TEST"
        textStackView.addArrangedSubview(nameLabel)
        
        if let spell = spell{
            
            var combinedDesc = [Any]()
            
            if let tables = spell.table{

                
                let commonLength = min(spell.description.count, tables.count)
                combinedDesc = zip(spell.description, tables).flatMap { [$0, $1] }

                for desc in spell.description.suffix(from: commonLength){
                    combinedDesc.append(desc)
                }
                
                for table in tables.suffix(from: commonLength){
                    combinedDesc.append(table)
                }
                
                for items in combinedDesc{
                    if let desc = items as? [String]{
                        let newLabel = UILabel()
                        newLabel.text = desc.joined(separator: "\n\n")
                        newLabel.font = UIFont(name: "TeXGyreBonum-Regular", size: 15)
                        newLabel.numberOfLines = 0
                        stackView.addArrangedSubview(newLabel)
                    } else if let table = items as? [[String]]{
                        self.tables.append(UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout()))
                        self.tables[numTables].dataSource = self
                        self.tables[numTables].delegate = self
                        self.tables[numTables].register(MyCollectionViewCell.self, forCellWithReuseIdentifier: String(numTables))
                        self.tables[numTables].backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
                        self.stackView.addArrangedSubview(self.tables[numTables])
                        let constraintHeight = NSLayoutConstraint(item: self.tables[numTables], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(table.count*38))
                        self.view.addConstraint(constraintHeight)
                        
                        self.tableData.append([String]())
                        self.tableData[numTables].append(String(table[0].count))
                        for row in table{
                            for cell in row{
                                self.tableData[numTables].append(cell)
                            }
                        }
                        
                        
                        
                        numTables += 1
                    }
                }
                
            } else{
                let newLabel = UILabel()
                newLabel.text = spell.description[0].joined(separator: "\n\n")
                newLabel.font = UIFont(name: "TeXGyreBonum-Regular", size: 15)
                newLabel.numberOfLines = 0
                stackView.addArrangedSubview(newLabel)
            }
            
            nameLabel.text = spell.name
            
            var formattedString = NSMutableAttributedString()
            
            formattedString.bold("Range: ").normal(spell.range)
            rangeLabel.attributedText = formattedString
            formattedString = NSMutableAttributedString()
            
            formattedString.bold("Duration: ").normal(spell.duration)
            durationLabel.attributedText = formattedString
            formattedString = NSMutableAttributedString()
            
            formattedString.bold("Area of Effect: ").normal(spell.area_of_effect)
            areaOfEffectLabel.attributedText = formattedString
            formattedString = NSMutableAttributedString()
            
            formattedString.bold("Casting Time: ").normal(spell.casting_time)
            castingTimeLabel.attributedText = formattedString
            formattedString = NSMutableAttributedString()
            
            formattedString.bold("Saving Throw: ").normal(spell.saving_throw)
            savingThrowLabel.attributedText = formattedString
            formattedString = NSMutableAttributedString()
            
            formattedString.bold("Components: ").normal(spell.components)
            componentsLabel.attributedText = formattedString
            
            
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        for table in tables{
            guard let flowLayout = table.collectionViewLayout as? UICollectionViewFlowLayout else {
                return
            }
            table.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let index = (tables.index(of: collectionView))!
        return tableData[index].count-1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = (tables.index(of: collectionView))!
        let numItems = CGFloat(Int(tableData[index][0])!)
        
        
        let paddingSpace = (sectionInsets.left) * ( numItems)
        let availableWidth = collectionView.bounds.size.width - paddingSpace
        let widthPerItem = availableWidth / numItems
        
        return CGSize(width: widthPerItem, height: 38)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = tables.index(of: collectionView)!
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: index), for: indexPath as IndexPath) as! MyCollectionViewCell

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.text = tableData[index][indexPath.item + 1]
        
        let numItems = Int(tableData[index][0])!
        
        if(indexPath.item/numItems % 2 == 1){
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "TeXGyreBonum-Bold", size: 17)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}
