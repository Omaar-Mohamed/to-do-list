//
//  ToDoTableViewCell.h
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *todoText;
@property (weak, nonatomic) IBOutlet UIImageView *todoImage;


@end

NS_ASSUME_NONNULL_END
