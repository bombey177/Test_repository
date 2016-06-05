//
//  InfoViewController.m
//  Table_Super_Hero
//
//  Created by admin on 05.06.16.
//  Copyright (c) 2016 MrDifferential. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.hero){
        [self.nameField setText:[self.hero valueForKey:@"name"]];
        [self.universeField setText:[self.hero valueForKey:@"universe"]];
        [self.urlFiled setText:[self.hero valueForKey:@"url"]];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveButton:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.hero){
        [self.hero setValue:self.nameField.text forKey:@"name"];
        [self.hero setValue:self.universeField.text forKey:@"universe"];
        [self.hero setValue:self.urlFiled.text forKey:@"url"];
    }
    else{
        NSManagedObject *newHero = [NSEntityDescription insertNewObjectForEntityForName:@"Heroes" inManagedObjectContext:context];
        [newHero setValue:self.nameField.text forKey:@"name"];
        [newHero setValue:self.universeField.text forKey:@"universe"];
        [newHero setValue:self.urlFiled.text forKey:@"url"];
    }
    
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"Can't save; %@ %@", error, [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Saved" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

@end
