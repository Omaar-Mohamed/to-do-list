//
//  DoneViewController.h
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskDto.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController
< UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *doneTable;
@property NSMutableArray<TaskDto*> *tasks;

@property (nonatomic, strong) NSMutableArray<TaskDto *> *lowPriorityTasks;
@property (nonatomic, strong) NSMutableArray<TaskDto *> *mediumPriorityTasks;
@property (nonatomic, strong) NSMutableArray<TaskDto *> *highPriorityTasks;
@end

NS_ASSUME_NONNULL_END
