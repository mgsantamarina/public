//
//  ColorPickerImageView.h
//  Release
//
//  Created by Miguel Garcia-Santamarina Armesto on 7/16/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorPickerImageView : UIImageView {
	UIColor* lastColor;
	id pickedColorDelegate;
}

@property (nonatomic, retain) UIColor* lastColor;
@property (nonatomic, retain) id pickedColorDelegate;

-(UIColor*)getPixelColorAtLocation:(CGPoint)point;
-(CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;

@end

