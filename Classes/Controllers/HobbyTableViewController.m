//
//  HobbyTableViewController.m
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "HobbyTableViewController.h"
#import "CoreDataManager.h"
#import <XCDYouTubeKit/XCDYouTubeVideoPlayerViewController.h>

static NSString *HobbyCellIdentifier = @"hobbyCell";

@interface HobbyTableViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) NSValue *initialHeaderFrameValue;

@end

@implementation HobbyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initialHeaderFrameValue = [NSValue valueWithCGRect:self.headerImageView.frame];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.hobbies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HobbyCellIdentifier];
    CDHobby *hobby = self.hobbies[indexPath.row];
    cell.textLabel.text = hobby.name;
    cell.detailTextLabel.text = hobby.genre;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HobbyModel *hobby = self.hobbies[indexPath.row];
    
    //Parse then present youtube controller
    NSString *vID = nil;
    NSString *query = [hobby.link componentsSeparatedByString:@"?"][1];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if ([kv[0] isEqualToString:@"v"]) {
            vID = kv[1];
            break;
        }
    }
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:vID];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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

@end
