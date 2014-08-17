//
//  Team.h
//  Skyrise Scout
//
//  Created by Ryan Benasutti on 8/17/14.
//  Copyright (c) 2014 Octogonaus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * autonConsistency;
@property (nonatomic, retain) NSString * autonPoints;
@property (nonatomic, retain) NSNumber * canBuildSkyrise;
@property (nonatomic, retain) NSNumber * driveSpeed;
@property (nonatomic, retain) NSString * driveType;
@property (nonatomic, retain) NSString * liftMaxHeight;
@property (nonatomic, retain) NSNumber * liftSpeed;
@property (nonatomic, retain) NSString * liftType;
@property (nonatomic, retain) NSString * maxSections;
@property (nonatomic, retain) NSData * robotPicture;
@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * teamNumber;
@property (nonatomic, retain) NSNumber * intakeSpeed;
@property (nonatomic, retain) NSString * maxHeldCubes;

@end
