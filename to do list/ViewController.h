//
//  ViewController.h
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskDto.h"

@interface ViewController : UIViewController
< UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate>

@property NSMutableArray<TaskDto*> *tasks;

@property (nonatomic, strong) NSMutableArray<TaskDto *> *lowPriorityTasks;
@property (nonatomic, strong) NSMutableArray<TaskDto *> *mediumPriorityTasks;
@property (nonatomic, strong) NSMutableArray<TaskDto *> *highPriorityTasks;





@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
- (IBAction)AddNewTask:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

