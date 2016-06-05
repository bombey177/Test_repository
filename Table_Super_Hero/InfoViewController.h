//
//  InfoViewController.h
//  Table_Super_Hero
//
//  Created by admin on 05.06.16.
//  Copyright (c) 2016 MrDifferential. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface InfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *urlFiled;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *universeField;
- (IBAction)saveButton:(id)sender;
@property (strong) NSManagedObject *hero;

@end
