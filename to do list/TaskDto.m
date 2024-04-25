//
//  TaskDto.m
//  to do list
//
//  Created by Omar  on 21/04/2024.
//

#import "TaskDto.h"

@implementation TaskDto

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _taskDescription = [aDecoder decodeObjectForKey:@"taskDescription"];
        _priority = [aDecoder decodeObjectForKey:@"priority"];
//        _dateOfCreation = [aDecoder decodeObjectForKey:@"dateOfCreation"];
        _imagePath = [aDecoder decodeObjectForKey:@"imagePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [aCoder encodeObject:self.priority forKey:@"priority"];
//    [aCoder encodeObject:self.dateOfCreation forKey:@"dateOfCreation"];
    [aCoder encodeObject:self.imagePath forKey:@"imagePath"];
}

- (id)copyWithZone:(NSZone *)zone {
    TaskDto *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        // Copy each property to the new object
        copy.name = [self.name copyWithZone:zone];
        copy.taskDescription = [self.taskDescription copyWithZone:zone];
        copy.priority = [self.priority copyWithZone:zone];
//        copy.dateOfCreation = [self.dateOfCreation copyWithZone:zone];
        copy.imagePath = [self.imagePath copyWithZone:zone];
    }
    return copy;
}


@end
