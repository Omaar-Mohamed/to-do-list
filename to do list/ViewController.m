//
//  ViewController.m
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import "ViewController.h"
#import "TaskDto.h"
#import "ToDoTableViewCell.h"
#import "EdittTaskViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.todoTableView.delegate = self;
    self.todoTableView.dataSource = self;
    self.searchBar.delegate=self;
//    NSData * savedToDoTasks =[[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
//    self.tasks =[NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
    self.navigationController.delegate = self;

}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [self.tabBarController.tabBar setHidden:NO];
    }else{
        [self.tabBarController.tabBar setHidden:YES];

    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    
    // Retrieve ToDo tasks from UserDefaults
    NSData *savedToDoTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
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
            
            
            [self.todoTableView reloadData];
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
    task.imagePath = imageUrl;
    return task;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.highPriorityTasks count];
    } else if (section == 1) {
        return [self.mediumPriorityTasks count];
    } else {
        return [self.lowPriorityTasks count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    
    TaskDto *task;
    if (indexPath.section == 0) {
        task = self.highPriorityTasks[indexPath.row];
    } else if (indexPath.section == 1) {
        task = self.mediumPriorityTasks[indexPath.row];
    } else {
        task = self.lowPriorityTasks[indexPath.row];
    }
    
    cell.todoText.text = task.name;
    cell.imageView.image = [UIImage imageNamed:task.imagePath];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"High Priority";
    } else if (section == 1) {
        return @"Medium Priority";
    } else {
        return @"Low Priority";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskDto *selectedTask;
    EdittTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editTask"];
    switch (indexPath.section) {
        case 0:
            selectedTask = self.highPriorityTasks[indexPath.row];
            editTaskVC.editTaskType = @"High";
            break;
        case 1:
            selectedTask = self.mediumPriorityTasks[indexPath.row];
            editTaskVC.editTaskType = @"Medium";
            break;
        case 2:
            selectedTask = self.lowPriorityTasks[indexPath.row];
            editTaskVC.editTaskType = @"Low";

            break;
        default:
            break;
    }
//    NSData *savedToDoTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
//    if (savedToDoTasks) {
//        NSArray<TaskDto *> *unarchivedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
//        if (unarchivedTasks) {
//            self.tasks = [NSMutableArray arrayWithArray:unarchivedTasks];}
//    }
    NSInteger index = [self.tasks indexOfObject:selectedTask];
    
    editTaskVC.whereFrom = @"edit";
    editTaskVC.editItemIndex = index;
    printf("%ld", (long)index);
    editTaskVC.recivedTask = selectedTask;
    
    [self.navigationController pushViewController:editTaskVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
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
        
        [self saveTasks:allTasks forKey:@"Todo"];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


- (void)saveTasks:(NSArray *)tasks forKey:(NSString *)key {
    NSMutableArray *mutableTasks = [tasks mutableCopy]; // Convert to mutable array
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:mutableTasks];
    [[NSUserDefaults standardUserDefaults] setObject:encodedTasks forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)AddNewTask:(UIButton *)sender {
    EdittTaskViewController *editTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editTask"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editTaskVC animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        
        NSData *savedToDoTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
        if (savedToDoTasks) {
            NSArray<TaskDto *> *unarchivedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
            if (unarchivedTasks) {
                // Clear existing arrays
                [self.lowPriorityTasks removeAllObjects];
                [self.mediumPriorityTasks removeAllObjects];
                [self.highPriorityTasks removeAllObjects];
                
                for (TaskDto *task in unarchivedTasks) {
                    if ([task.priority isEqualToString:@"Low"]) {
                        [self.lowPriorityTasks addObject:task];
                    } else if ([task.priority isEqualToString:@"Medium"]) {
                        [self.mediumPriorityTasks addObject:task];
                    } else if ([task.priority isEqualToString:@"High"]) {
                        [self.highPriorityTasks addObject:task];
                    }
                }
            }
        }
    } else {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
        NSArray<TaskDto *> *filteredTasks = [self.tasks filteredArrayUsingPredicate:predicate];
        
        [self.lowPriorityTasks removeAllObjects];
        [self.mediumPriorityTasks removeAllObjects];
        [self.highPriorityTasks removeAllObjects];
        
        for (TaskDto *task in filteredTasks) {
            if ([task.priority isEqualToString:@"Low"]) {
                [self.lowPriorityTasks addObject:task];
            } else if ([task.priority isEqualToString:@"Medium"]) {
                [self.mediumPriorityTasks addObject:task];
            } else if ([task.priority isEqualToString:@"High"]) {
                [self.highPriorityTasks addObject:task];
            }
        }
    }
    
    [self.todoTableView reloadData];
}




@end
