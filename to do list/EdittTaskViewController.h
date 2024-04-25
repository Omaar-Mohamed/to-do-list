//
//  EdittTaskViewController.h
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskDto.h"

NS_ASSUME_NONNULL_BEGIN

@interface EdittTaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *editImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTF;
- (IBAction)setPriority:(UISegmentedControl *)sender;
- (IBAction)setType:(UISegmentedControl *)sender;
- (IBAction)date:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)editBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;

@property NSMutableArray<TaskDto*> *toDoTasks;
@property NSMutableArray<TaskDto*> *inProgressTasks;
@property NSMutableArray<TaskDto*> *doneTasks;
@property NSString *selectedPriority;
@property NSString *selectedType;

@property (nonatomic, strong) TaskDto *recivedTask;
@property (nonatomic, strong) NSString *whereFrom;
@property (nonatomic, strong) NSString *editTaskType;
@property NSInteger editItemIndex;



@end

NS_ASSUME_NONNULL_END
