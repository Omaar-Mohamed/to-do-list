//
//  InProgressViewController.m
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import "InProgressViewController.h"

@interface InProgressViewController ()

@end

@implementation InProgressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.inProgressTableView.delegate = self;
    self.inProgressTableView.dataSource = self;
//    NSData * savedToDoTasks =[[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
//    self.tasks =[NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
    self.navigationController.delegate = self;

}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        // Show the tab bar
        [self.tabBarController.tabBar setHidden:NO];
    }else{
        [self.tabBarController.tabBar setHidden:YES];

    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    
    NSData *savedToDoTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"In Progress"];
    if (savedToDoTasks) {
        NSArray<TaskDto *> *unarchivedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
        if (unarchivedTasks) {
            self.tasks = [NSMutableArray arrayWithArray:unarchivedTasks];
            NSLog(@"Retrieved %lu tasks from UserDefaults.", (unsigned long)[self.tasks count]);
            
            
            _lowPriorityTasks = [NSMutableArray array];
            _mediumPriorityTasks = [NSMutableArray array];
            _highPriorityTasks = [NSMutableArray array];

            for (TaskDto *task in self.tasks) {
                if ([task.priority isEqualToString:@"Low"]) {
                    [_lowPriorityTasks addObject:task];
                } else if ([task.priority isEqualToString:@"Medium"]) {
                    [_mediumPriorityTasks addObject:task];
                } else if ([task.priority isEqualToString:@"High"]) {
                    [_highPriorityTasks addObject:task];
                }
            }
            
            
            [self.inProgressTableView reloadData];
        } else {
            NSLog(@"Failed to unarchive tasks from UserDefaults.");
        }
    } else {
        NSLog(@"No tasks found in UserDefaults for key 'toDoTasks'.");
    }
}

- (TaskDto *)createTaskWithName:(NSString *)name description:(NSString *)description priority:(NSString *)priority imageUrl:(NSString *)imageUrl {
    TaskDto *task = [[TaskDto alloc] init];
    task.name = name;
    task.taskDescription = description;
    task.priority = priority;
//    task.dateOfCreation = [NSDate date]; // Assuming current date/time
    task.imagePath = imageUrl;
    return task;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections based on the number of priority levels
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Determine the number of rows in each section based on the tasks array
    if (section == 0) {
        return [self.highPriorityTasks count];
    } else if (section == 1) {
        return [self.mediumPriorityTasks count];
    } else {
        return [self.lowPriorityTasks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inprogresscell" forIndexPath:indexPath];
    
    TaskDto *task;
    if (indexPath.section == 0) {
        task = self.highPriorityTasks[indexPath.row];
    } else if (indexPath.section == 1) {
        task = self.mediumPriorityTasks[indexPath.row];
    } else {
        task = self.lowPriorityTasks[indexPath.row];
    }
    
    cell.textLabel.text = task.name;
    cell.imageView.image = [UIImage imageNamed:task.imagePath];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Return section titles based on priority levels
    if (section == 0) {
        return @"High Priority";
    } else if (section == 1) {
        return @"Medium Priority";
    } else {
        return @"Low Priority";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    EdittTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editTask"];
    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:editTaskVC animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        switch (indexPath.section) {
            case 0:
                if (self.highPriorityTasks.count > indexPath.row) {
                    [self.highPriorityTasks removeObjectAtIndex:indexPath.row];
                }
                break;
            case 1:
                if (self.mediumPriorityTasks.count > indexPath.row) {
                    [self.mediumPriorityTasks removeObjectAtIndex:indexPath.row];
                }
                break;
            case 2:
                if (self.lowPriorityTasks.count > indexPath.row) {
                    [self.lowPriorityTasks removeObjectAtIndex:indexPath.row];
                }
                break;
            default:
                break;
        }
        
        NSArray<TaskDto *> *allTasks = [NSArray<TaskDto *> array];
        allTasks = [allTasks arrayByAddingObjectsFromArray:self.highPriorityTasks];
        allTasks = [allTasks arrayByAddingObjectsFromArray:self.mediumPriorityTasks];
        allTasks = [allTasks arrayByAddingObjectsFromArray:self.lowPriorityTasks];
        
        [self saveTasks:allTasks forKey:@"In Progress"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)saveTasks:(NSArray *)tasks forKey:(NSString *)key {
    NSMutableArray *mutableTasks = [tasks mutableCopy]; // Convert to mutable array
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:mutableTasks];
    [[NSUserDefaults standardUserDefaults] setObject:encodedTasks forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
