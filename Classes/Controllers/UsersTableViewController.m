//
//  UsersTableViewController.m
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UserService.h"
#import "HobbyTableViewController.h"
#import "CustomNavigationAnimationController.h"
#import "CustomNavigationInteractionController.h"
#import "CoreDataManager.h"

#import <SVProgressHUD/SVProgressHUD.h>

static NSString *UserCellIdentifier = @"userCell";

@interface UsersTableViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) NSValue *initialHeaderFrameValue;
@property (assign, nonatomic) NSInteger selectedUserIndex;
@property (strong, nonatomic) CustomNavigationAnimationController *customNavigationAnimationController;
@property (strong, nonatomic) CustomNavigationInteractionController *customNavigationInteractionController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation UsersTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    
    [self loadData];
}

#pragma mark - Setup
- (void)configureUI
{
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.initialHeaderFrameValue = [NSValue valueWithCGRect:self.headerImageView.frame];
    self.customNavigationAnimationController = [[CustomNavigationAnimationController alloc] init];
    self.customNavigationInteractionController = [[CustomNavigationInteractionController alloc] init];
    self.navigationController.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    CDUser *user = [self userAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedUserIndex = indexPath.row;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Hobbies"
                                                                   message:@"Which hobby do you want to see?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *musicAction = [UIAlertAction actionWithTitle:@"Music" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self performSegueWithIdentifier:@"showMusic" sender:self];
                                                          }];
    
    UIAlertAction *gameAction = [UIAlertAction actionWithTitle:@"Games" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self performSegueWithIdentifier:@"showGames" sender:self];
                                                        }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                     handler:nil];
    
    [actionSheet addAction:musicAction];
    [actionSheet addAction:gameAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [CoreDataManager removeUser:[self userAtIndexPath:indexPath]];
    }
}

#pragma mark - Scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger offset = scrollView.contentOffset.y;
    if (offset < 0) {
        self.headerImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.headerImageView.frame) - offset, CGRectGetHeight(self.headerImageView.frame) - offset);
        [self.tableView setTableHeaderView:self.headerImageView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self performScrollDoneAnimation];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performScrollDoneAnimation];
}

#pragma mark - Navigation animation delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.customNavigationAnimationController.reverse = (operation == UINavigationControllerOperationPop);
    if (operation == UINavigationControllerOperationPush) {
        [self.customNavigationInteractionController attachToVC:toVC];
    }
    return self.customNavigationAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.customNavigationInteractionController.transitionIsInProgress) {
        return self.customNavigationInteractionController;
    }
    return nil;
}

#pragma mark - Utility
- (CDUser *)userAtIndexPath:(NSIndexPath *)indexPath
{
    return (CDUser *)[self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)performScrollDoneAnimation
{
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.headerImageView.frame = [self.initialHeaderFrameValue CGRectValue];
            [self.tableView setTableHeaderView:self.headerImageView];
        }];
    }
}

- (void)showFailureToLoadAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops!"
                                                                   message:@"It seems the data failed to load..."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadData
{
    if ([CoreDataManager atLeastOneItemPresent]) {
        [self performFetchRequest];
    } else {
        [SVProgressHUD show];
        [UserService getUsersWithCompletion:^(NSArray *users) {
            [SVProgressHUD popActivity];
            for (UserModel *user in users) {
                [CoreDataManager addUserFromAPIModel:user];
            }
            [self performFetchRequest];
        } failure:^(NSError *error) {
            [SVProgressHUD popActivity];
            [self showFailureToLoadAlert];
        }];
    }
}

#pragma mark - NSFetchedResultsController
- (void)performFetchRequest
{
    NSError *error;
    
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"ERROR WHILE FETCHING: %@", error.localizedDescription);
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    } else {
        NSFetchRequest *fetchRequest = [self defaultFetchRequest];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        fetchedResultsController.delegate = self;
        
        _fetchedResultsController = fetchedResultsController;
        
        NSError *error;
        
        [_fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"ERROR WHILE FETCHING: %@", error.localizedDescription);
        }
        
        return _fetchedResultsController;
    }
}

- (NSFetchRequest *)defaultFetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    fetchRequest.entity = entityDescription;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return fetchRequest;
}

#pragma mark - Fetched results controller delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
            
        case NSFetchedResultsChangeUpdate:
            [self performFetchRequest];
            break;
            
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HobbyTableViewController *hobbyTVC = (HobbyTableViewController *)segue.destinationViewController;
    CDUser *coreDataUser = [self userAtIndexPath:[NSIndexPath indexPathForRow:self.selectedUserIndex inSection:0]];
    
    if ([segue.identifier isEqualToString:@"showMusic"]) {
        hobbyTVC.hobbies = [coreDataUser.bands allObjects];
    } else if ([segue.identifier isEqualToString:@"showGames"]) {
        hobbyTVC.hobbies = [coreDataUser.games allObjects];
    }
}

@end
