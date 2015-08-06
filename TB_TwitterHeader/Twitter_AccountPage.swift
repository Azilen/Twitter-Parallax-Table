//
//  Twitter_AccountPage.swift

//  Created by Chandni Gohil on 8/3/15.

import UIKit

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 95.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label
let height_tableViewHeader:CGFloat = 205.0
let offset_ForSegment:CGFloat = 135.0
let topMargine_Tableview:CGFloat = 69.0
let horizontal_margineSC:CGFloat = 10.0
let vertical_margineSC:CGFloat = 5.0
let height_SC:CGFloat = 30.0
let height_view:CGFloat = 40.0
let imgName:String = "header_bg"


class Twitter_AccountPage: UIViewController,  UITableViewDelegate {


    @IBOutlet var topConstraintTableView: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var header:UIView!
    @IBOutlet var headerLabel:UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    var blurredHeaderImageView:UIImageView?
    var isOffsetSet: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //self.topConstraintTableView.constant = 80
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Header - Image
        
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: imgName)
        headerImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
        
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerBlurImageView?.image = UIImage(named: imgName)?.blurredImageWithRadius(10, iterations: 20, tintColor: UIColor.clearColor())
        headerBlurImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(headerBlurImageView, belowSubview: headerLabel)
        
        header.clipsToBounds = true
        isOffsetSet = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0)
            headerLabel.layer.transform = labelTransform

            
            if offset >= offset_ForSegment{
         
                self.topConstraintTableView.constant = topMargine_Tableview
               
                if !isOffsetSet{
                self.tableView.setContentOffset(CGPointMake(0, height_tableViewHeader), animated: false)
                isOffsetSet = true
                }
            }
            else{
            self.topConstraintTableView.constant = 0
           
                if isOffsetSet == true {
                self.tableView.setContentOffset(CGPointMake(0, topMargine_Tableview), animated: false)
                    isOffsetSet = false
                }
            }
            
            //  ------------ Blur
            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
                if avatarImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
            }
                
            }else {
                if avatarImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                    
                }
            }
        }
        
        // Apply Transformations
        
        header.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform
    }
    
    //tableview delegate method 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
   func numberOfSectionsInTableView(tableView: UITableView) -> Int
     {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        var img = cell.viewWithTag(10) as! UIImageView
        img.layer.cornerRadius = 5
        img.layer.masksToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let viewSc:UIView = UIView(frame: CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height_view))
        viewSc.backgroundColor = UIColor.whiteColor()
        
        let items = ["Tweets","Photos","Favorites"];
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0;
        customSC.frame = CGRectMake(self.tableView.frame.minX + horizontal_margineSC, self.tableView.frame.minY + vertical_margineSC,
            self.tableView.frame.width - 20, height_SC)
        customSC.layer.cornerRadius = 5.0
        
        viewSc.addSubview(customSC)
        
        return viewSc
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
    return 40
    }
    
    @IBAction func shamelessActionThatBringsYouToMyTwitterProfile() {
        
        UIApplication.sharedApplication().openURL(NSURL(string:"https://twitter.com/")!)

    }

}
