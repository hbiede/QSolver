//
//  QSolver.m
//  Quadratic Solver
//
//  Created by Hundter Biede on 9/20/18.
//  Copyright © 2018 Hundter Biede. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSolver.h"

@implementation QSolver {
    NSNumber *a;
    NSNumber *b;
    NSNumber *c;

}

/// Sets the value of A. Only sets A if non-zero.
- (void) setA:(NSNumber *)input
{
    if (input != 0) {
        a = input;
    }
}

/// Sets the value of B.
- (void) setB:(NSNumber *)input
{
    b = input;
}

/// Sets the value of C.
- (void) setC:(NSNumber *)input
{
    c = input;
}

/// Sets the value of A, B, and C. Only sets A if non-zero.
- (void) setValues:(NSNumber *)newA b:(NSNumber *)newB c:(NSNumber *)newC
{
    [self setA:newA];
    [self setB:newB];
    [self setC:newC];
}

///Returns the value of the solution as a string in the following format:
/// """-b ± √(b^2-4ac)
///    ---------------
///          2a         """
- (NSString *) getSolutionAsString
{
    double numberSolution = [self getSolutionAsNumberPositive];
    if (numberSolution == floor(numberSolution) && numberSolution == [self getSolutionAsNumberNegative]) {
        return [NSString stringWithFormat:@"%f", numberSolution];
    }

    double usableA;
    double usableB;
    double usableC;

    usableA = a.doubleValue;
    usableB = b.doubleValue;
    usableC = c.doubleValue;

    double i = 1;

    // Make a, b, and c whole numbers.
    while (usableA != floor(usableA) || usableB != floor(usableB) || usableC != floor(usableC)) {
        i += 1;
        if (usableA * i == floor(usableA * i) || usableB * i == floor(usableB * i) || usableC * i == floor(usableC * i)) {
            usableA *= i;
            usableB *= i;
            usableC *= i;
        }
    }

    int determinant = pow(usableB, 2) - 4 * usableA * usableC;

    // If determinant == 0, return a reduced fraction of the result in the form "n/d DR".
    if (determinant == 0) {
        int numeratorValue = -usableB;
        int denominatorValue = 2 * usableA;
        for (int i = 1; i <= denominatorValue || i <= numeratorValue; i++) {
            if (numeratorValue % i == 0 && denominatorValue % i == 0) {
                numeratorValue /= i;
                denominatorValue /= i;
            }
        }
        return denominatorValue == 1 ? [NSString stringWithFormat:@"%d", numeratorValue] : [NSString stringWithFormat:@"%d/%d", numeratorValue, denominatorValue];
    }


    int numerator;
    int denominator = 2 * (int)usableA;
    int reducedDeterminant = determinant;
    int determinantMultiplier = 1;
    NSString *imaginary = @"";
    //Prevent errors from imaginary numbers.
    if (determinant < 0) {
        determinant = abs(determinant);
        imaginary = @"i";
    }

    //If determinant == 1, numerator simplifies to a single number, else format the numerator and denominator and reduce.
    if (floor(sqrt(determinant)) == sqrt(determinant)) {
        numerator = (int)(-usableB + determinant);
        for (int i = 0; i <= denominator && i <= numerator; i++) {
            if (numerator % i == 0 && denominator % i == 0) {
                numerator /= i;
                denominator /= i;
            }
        }
        return denominator == 1 ? [NSString stringWithFormat:@"%d", numerator] : [NSString stringWithFormat:@"%d/%d", numerator, denominator];
    } else {
        for (int i = 1; pow(i, 2) <= determinant; i++) {
            if (fmod(pow(i, 2), determinant) == 0) {
                reducedDeterminant /= pow(i, 2);
                determinantMultiplier *= i;
            }
        }
        for (int i = 0; i <= denominator && i <= reducedDeterminant && i <= determinantMultiplier; i++) {
            if (reducedDeterminant % i == 0 && determinantMultiplier % i == 0 && denominator % i == 0) {
                reducedDeterminant /= i;
                determinantMultiplier /= i;
                denominator /= i;
            }
        }
        NSString *formattedDeterminant;
        if (reducedDeterminant == 1) {
            if ([imaginary isEqualToString:@"i"]) {
                formattedDeterminant = determinantMultiplier == 1 ? @"i" : [NSString stringWithFormat:@"%di", determinantMultiplier];
            } else {
                formattedDeterminant = determinantMultiplier == 1 ? [NSString stringWithFormat:@"√(%d)", reducedDeterminant] : [NSString stringWithFormat:@"%d√(%d)", determinantMultiplier, reducedDeterminant];
            }
        }

        //Final return instructions for a classic quadratic solution with a non-1 solution.
        NSString *numeratorString = [NSString stringWithFormat:@"%d ± %@", (int)-usableB, formattedDeterminant];
        if (denominator == 1) {
            return numeratorString;
        } else {
            NSString *fractionBar = @"";
            for (int i = 0; i < numeratorString.length; i++) {
                fractionBar = [fractionBar stringByAppendingString:@"-"];
            }
            NSString *denominatorString = @"";
            for (int i = 0; i < numeratorString.length / 2; i++) {
                denominatorString = [denominatorString stringByAppendingString:@" "];
            }
            denominatorString = [NSString stringWithFormat:@"%@%d", denominatorString, denominator];
            [NSString stringWithFormat:@"%@%@%@", numeratorString, fractionBar, denominatorString];
        }
    }
    return @"ERROR";
}

/// Returns a boolean representing if the solution to the equation for the current values of a, b, and c has a real number solution
- (BOOL) isRealNumberSolution
{
    return (pow(b.doubleValue, 2) - 4 * a.doubleValue * c.doubleValue) < 0;
}

/// Returns the solution (achieved through adding in the numerator) as an NSNumber. If the solution is imaginary, returns -1;
- (double) getSolutionAsNumberPositive
{
    if ([self isRealNumberSolution]) {
        return (-b.doubleValue + (pow(b.doubleValue, 2) - 4 * a.doubleValue * c.doubleValue))/(2*a.doubleValue);
    }
    return -1;
}

/// Returns the solution (achieved through subtracting in the numerator) as an NSNumber. If the solution is imaginary, returns -1;
- (double) getSolutionAsNumberNegative
{
    if ([self isRealNumberSolution]) {
        return (-b.doubleValue - (pow(b.doubleValue, 2) - 4 * a.doubleValue * c.doubleValue))/(2*a.doubleValue);
    }
    return -1;
}

@end
