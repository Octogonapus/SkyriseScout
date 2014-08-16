//
//  Team.h
//  Skyrise Scout
//
//  Created by Ryan Benasutti on 8/15/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Team : NSManagedObject

@property (nonatomic, retain) id robotPicture;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * teamNumber;
@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSNumber * driveSpeed;
@property (nonatomic, retain) NSString * driveType;
@property (nonatomic, retain) NSNumber * liftSpeed;
@property (nonatomic, retain) NSString * liftType;
@property (nonatomic, retain) NSString * liftMaxHeight;
@property (nonatomic, retain) NSNumber * autonConsistency;
@property (nonatomic, retain) NSNumber * autonPoints;
@property (nonatomic, retain) NSNumber * canBuildSkyrise;
@property (nonatomic, retain) NSString * maxSections;

@end
