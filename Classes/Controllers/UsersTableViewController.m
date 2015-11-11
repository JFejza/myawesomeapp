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

#import <SVProgressHUD/SVProgressHUD.h>

static NSString *UserCellIdentifier = @"userCell";

@interface UsersTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (strong, nonatomic) NSValue *initialHeaderFrameValue;
@property (strong, nonatomic) NSArray *users;
@property (assign, nonatomic) NSInteger selectedUserIndex;

@end

@implementation UsersTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.initialHeaderFrameValue = [NSValue valueWithCGRect:self.headerImageView.frame];
    
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
    UserModel *user = self.users[indexPath.row];
    cell.textLabel.text = user.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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

#pragma mark - Utility
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
    [SVProgressHUD show];
    [UserService getUsersWithCompletion:^(NSArray *users) {
        [SVProgressHUD popActivity];
        self.users = users;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD popActivity];
        [self showFailureToLoadAlert];
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HobbyTableViewController *hobbyTVC = (HobbyTableViewController *)segue.destinationViewController;
    UserModel *user = self.users[self.selectedUserIndex];
    if ([segue.identifier isEqualToString:@"showMusic"]) {
        hobbyTVC.hobbies = user.bands;
    } else if ([segue.identifier isEqualToString:@"showGames"]) {
        hobbyTVC.hobbies = user.games;
    }
}

@end
