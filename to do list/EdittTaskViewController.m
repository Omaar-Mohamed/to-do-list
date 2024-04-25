//
//  EdittTaskViewController.m
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import "EdittTaskViewController.h"
#import "TaskDto.h"
@interface EdittTaskViewController ()

@end

@implementation EdittTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Initialize the arrays
    if([self.whereFrom isEqualToString:@"edit"]){
        self.titleTF.text = self.recivedTask.name;
    self.descriptionTF.text = self.recivedTask.taskDescription;
    }
        _toDoTasks = [NSMutableArray array];
        _inProgressTasks = [NSMutableArray array];
        _doneTasks = [NSMutableArray array];
        
    
    NSData *savedToDoTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Todo"];
    printf("%ld", (long)[savedToDoTasks accessibilityElementCount]);
    if (savedToDoTasks) {
        _toDoTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedToDoTasks];
    } else {
        _toDoTasks = [NSMutableArray array]; // Initialize an empty array if no data is found
    }
    
    // Retrieve In Progress tasks from UserDefaults
    NSData *savedInProgressTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"In Progress"];
    if (savedInProgressTasks) {
        _inProgressTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedInProgressTasks];
    } else {
        _inProgressTasks = [NSMutableArray array]; // Initialize an empty array if no data is found
    }
    
    // Retrieve Done tasks from UserDefaults
    NSData *savedDoneTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"Done"];
    if (savedDoneTasks) {
        _doneTasks = [NSKeyedUnarchiver unarchiveObjectWithData:savedDoneTasks];
    } else {
        _doneTasks = [NSMutableArray array]; // Initialize an empty array if no data is found
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)date:(UIDatePicker *)sender {
}

- (IBAction)setType:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    
    
    switch (selectedIndex) {
        case 0:
            _selectedType = @"Todo";
            break;
        case 1:
            _selectedType = @"In Progress";
            break;
        case 2:
            _selectedType = @"Done";
            break;
        default:
            // Handle any unexpected cases here
            break;
    }

}

- (IBAction)setPriority:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    
    switch (selectedIndex) {
        case 0:
            _selectedPriority = @"High";
            break;
        case 1:
            _selectedPriority = @"Medium";
            break;
        case 2:
            _selectedPriority = @"Low";
            break;
        default:
            // Handle any unexpected cases here
            break;
    }
    

}

- (IBAction)editBtn:(UIButton *)sender {
    if([self.whereFrom isEqualToString:@"edit"]){
        // Handle editing an existing task with confirmation
        [self showEditConfirmationAlert];
    } else {
        // Handle adding a new task
        [self addNewTask];
    }
}

- (void)showEditConfirmationAlert {
    NSString *title = _titleTF.text;
    NSString *description = _descriptionTF.text;
    NSString *priority = _selectedPriority;
    
    // Perform validation
    if (title.length == 0 || description.length == 0 || priority.length == 0) {
        // Display an alert or handle the validation failure in some way
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Validation Error"
                                                                       message:@"Please fill in all fields."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                                message:@"Are you sure you want to save changes to this task?"
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save Changes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Save the task
        [self editExistingTask];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [confirmationAlert addAction:saveAction];
    [confirmationAlert addAction:cancelAction];
    
    [self presentViewController:confirmationAlert animated:YES completion:nil];
}


- (void)editExistingTask {
    NSString *title = _titleTF.text;
    NSString *description = _descriptionTF.text;
    NSString *priority = _selectedPriority;
    
    // Perform validation
    if (title.length == 0 || description.length == 0 || priority.length == 0) {
        // Display an alert or handle the validation failure in some way
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Validation Error"
                                                                       message:@"Please fill in all fields."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (self.editItemIndex >= 0 && self.editItemIndex < self.toDoTasks.count) {
        TaskDto *taskToEdit = self.toDoTasks[self.editItemIndex];
        
        taskToEdit.name = title;
        taskToEdit.taskDescription = description;
        taskToEdit.priority = priority;
        
        if ([priority isEqualToString:@"Low"]) {
            taskToEdit.imagePath = @"low.png";
        } else if ([priority isEqualToString:@"High"]) {
            taskToEdit.imagePath = @"high.png";
        } else if ([priority isEqualToString:@"Medium"]) {
            taskToEdit.imagePath = @"med.png";
        }
        
        self.toDoTasks[self.editItemIndex] = taskToEdit;
        
        [self saveTasks:self.toDoTasks forKey:@"Todo"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addNewTask {
    NSString *title = _titleTF.text;
    NSString *description = _descriptionTF.text;
    NSString *priority = _selectedPriority;
    if(priority.length == 0 ){
        priority =@"High";
    }
    if(_selectedType.length == 0){
        _selectedType = @"Todo";
    }
    
    // Perform validation
    if (title.length == 0 || description.length == 0 || priority.length == 0) {
        // Display an alert or handle the validation failure in some way
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Validation Error"
                                                                       message:@"Please fill in all fields."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController *confirmationAlert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                                message:@"Are you sure you want to save this task?"
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Save the task
        [self saveTaskWithTitle:title description:description priority:priority];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [confirmationAlert addAction:saveAction];
    [confirmationAlert addAction:cancelAction];
    
    [self presentViewController:confirmationAlert animated:YES completion:nil];
}

    
    - (void)saveTaskWithTitle:(NSString *)title description:(NSString *)description priority:(NSString *)priority {
        TaskDto *task = [TaskDto new];
        [task setName:title];
        [task setTaskDescription:description];
        [task setPriority:priority];
        
        // Set image path based on priority
        if([priority isEqualToString:@"Low"]){
            [task setImagePath:@"low.png"];
        } else if([priority isEqualToString:@"High"]){
            [task setImagePath:@"high.png"];
        } else if([priority isEqualToString:@"Medium"]){
            [task setImagePath:@"med.png"];
        }
        
        if ([_selectedType isEqualToString:@"Todo"]) {
            [_toDoTasks addObject:task];
            [self saveTasks:_toDoTasks forKey:@"Todo"];
        } else if ([_selectedType isEqualToString:@"In Progress"]) {
            [_inProgressTasks addObject:task];
            [self saveTasks:_inProgressTasks forKey:@"In Progress"];
        } else if ([_selectedType isEqualToString:@"Done"]) {
            [_doneTasks addObject:task];
            [self saveTasks:_doneTasks forKey:@"Done"];
        }
    }



- (void)saveTasks:(NSArray *)tasks forKey:(NSString *)key {
    NSMutableArray *mutableTasks = [tasks mutableCopy]; // Convert to mutable array
    NSData *encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:mutableTasks];
    [[NSUserDefaults standardUserDefaults] setObject:encodedTasks forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}





@end
