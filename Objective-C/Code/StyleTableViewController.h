//
//  StyleTableViewController.h
//  Release
//
//  Created by Miguel Garcia-Santamarina Armesto on 7/23/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ColorPickerViewController.h"
#import "ImagePickerView.h"
#import "NSString+DataURI.h"
#import "NSData+Base64.h"

@class StyleTableViewController;

@protocol StyleTableViewControllerDelegate <NSObject>

- (void)styleTableViewControllerDidConfirm:
(StyleTableViewController *)controller withString:(NSString *)string;

- (void)styleTableViewControllerDidCancel:
(StyleTableViewController *)controller;

@end

@interface StyleTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ColorPickerControllerDelegate, ImagePickerViewDelegate>{
	
	IBOutlet UIPickerView *picker;
    IBOutlet UIButton *bStyleBold;
    IBOutlet UIButton *bStyleItalic;
    IBOutlet UITextField *tfSize;
     
    IBOutlet UIButton *bTextColor;
    IBOutlet UIButton *bAlignLeft;
    IBOutlet UIButton *bAlignRight;
    IBOutlet UIButton *bAlignCenter;
    IBOutlet UIButton *bAlignJustify;
    IBOutlet UIButton *bDecorationOver;
    IBOutlet UIButton *bDecorationUnder;
    IBOutlet UIButton *bDecorationThrough;
    IBOutlet UIButton *bBackgroundColor;
    IBOutlet UIButton *bBackgroundImage;
    
    NSMutableArray *maFamilies;
    NSMutableArray *maStyles;
    NSMutableArray *maImport;
    
    BOOL selectedTextColor;
        
}

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIButton *bStyleBold;
@property (nonatomic, retain) IBOutlet UIButton *bStyleItalic;
@property (nonatomic, retain) IBOutlet UITextField *tfSize;
@property (nonatomic, retain) IBOutlet UIButton *bTextColor;
@property (nonatomic, retain) IBOutlet UIButton *bAlignLeft;
@property (nonatomic, retain) IBOutlet UIButton *bAlignRight;
@property (nonatomic, retain) IBOutlet UIButton *bAlignCenter;
@property (nonatomic, retain) IBOutlet UIButton *bAlignJustify;
@property (nonatomic, retain) IBOutlet UIButton *bDecorationOver;
@property (nonatomic, retain) IBOutlet UIButton *bDecorationUnder;
@property (nonatomic, retain) IBOutlet UIButton *bDecorationThrough;
@property (nonatomic, retain) IBOutlet UIButton *bBackgroundColor;
@property (nonatomic, retain) IBOutlet UIButton *bBackgroundImage;
@property (nonatomic, retain) NSMutableArray *maFamilies;
@property (nonatomic, retain) NSMutableArray *maStyles;
@property (nonatomic, retain) NSMutableArray *maImport;
@property (nonatomic) BOOL selectedTextColor;
@property (nonatomic, weak) id <StyleTableViewControllerDelegate> delegate;

-(void)initializeStyles;
-(void)importStyles:(NSMutableArray *)stylesArray;
-(void)loadFontFamilies;
-(IBAction)selectButton:(UIButton*)sender;
-(NSString*)colorToHex:(UIColor*)color;
-(IBAction)selectBackgroundImage:(UIButton*)sender;
-(IBAction)removeBackgroundImage:(UIButton*)sender;
-(IBAction)removeBackgroundColor:(UIButton*)sender;
-(UIImage*)dyeImage:(UIColor*)color;

-(IBAction)confirmStyle;
-(IBAction)cancelStyle;

@end
