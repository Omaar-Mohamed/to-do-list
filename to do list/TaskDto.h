//
//  TaskDto.h
//  to do list
//
//  Created by Omar  on 21/04/2024.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskDto : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *taskDescription; // Renamed from 'description'
@property (nonatomic, copy) NSString *priority;
//@property (nonatomic, strong) NSDate *dateOfCreation;
@property (nonatomic, copy) NSString *imagePath;

@end

NS_ASSUME_NONNULL_END
