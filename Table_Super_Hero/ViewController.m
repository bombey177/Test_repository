//
//  ViewController.m
//  Table_Super_Hero
//
//  Created by admin on 05.06.16.
//  Copyright (c) 2016 MrDifferential. All rights reserved.
//

#import "ViewController.h"
#import "InfoViewController.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
@property (strong) NSMutableArray *heroes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Heroes"];
    self.heroes = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
}

- (NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [context deleteObject:[self.heroes objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]){
            NSLog(@"Can't delete; %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.heroes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.heroes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSManagedObject *hero = [self.heroes objectAtIndex:indexPath.row];
    [cell.textLabel setText:[hero valueForKey:@"name"]];
    [cell.detailTextLabel setText:[hero valueForKey:@"universe"]];
    NSURL *url = [hero valueForKey:@"url"];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"UpdateHero"]){
        NSManagedObject *selectedHero = [self.heroes objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        InfoViewController *destViewController = segue.destinationViewController;
        destViewController.hero = selectedHero;
    }
}

@end
