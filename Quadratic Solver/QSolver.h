//
//  QSolver.h
//  Quadratic Solver
//
//  Created by Hundter Biede on 9/20/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

#ifndef QSolver_h
#define QSolver_h

#import <Foundation/Foundation.h>

@interface QSolver : NSObject

+ (void) setA:(NSNumber *)input;
+ (void) setB:(NSNumber *)input;
+ (void) setC:(NSNumber *)input;
+ (void) setValues:(NSNumber *)newA b:(NSNumber *)newB c:(NSNumber *)newC;
+ (NSString *) getSolutionAsString;
+ (BOOL) isRealNumberSolution;
+ (double) getSolutionAsNumberPositive;
+ (double) getSolutionAsNumberNegative;

@end


#endif /* QSolver_h */
