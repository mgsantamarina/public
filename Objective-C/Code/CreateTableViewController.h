//
//  CreateTableViewController.h
//  Release
//
//  Created by Miguel Garcia-Santamarina Armesto on 10/23/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleTableViewController.h"
#import "ImagePickerView.h"

@class CreateTableViewController;

@protocol CreateTableViewControllerDelegate <NSObject>

- (void)createTableViewControllerDidConfirm:(CreateTableViewController *)controller withParams:(NSMutableArray *)array;
- (void)createTableViewControllerDidCancel:(CreateTableViewController *)controller;

@end

@interface CreateTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, StyleTableViewControllerDelegate, ImagePickerViewDelegate>{
	
    IBOutlet UIPickerView *picker;
    IBOutlet UITextView *tvText;
    
    IBOutlet UIButton *bFeedback;
    IBOutlet UIButton *bImage;
    IBOutlet UIButton *bStyles;
    
    UIImage *iTag;
    NSString *sTagName;
    NSString *sStyles;
    
    NSMutableArray *maParams;
    NSMutableArray *maTags;
    
    ImagePickerView *ipView;
    
}

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UITextView *tvText;
@property (nonatomic, retain) IBOutlet UIButton *bFeedback;
@property (nonatomic, retain) IBOutlet UIButton *bImage;
@property (nonatomic, retain) IBOutlet UIButton *bStyles;
@property (nonatomic, retain) UIImage *iTag;
@property (nonatomic, retain) NSString *sTagName;
@property (nonatomic, retain) NSString *sStyles;
@property (nonatomic, retain) NSMutableArray *maParams;
@property (nonatomic, retain) NSMutableArray *maTags;

@property (nonatomic, weak) id <CreateTableViewControllerDelegate> delegate;

-(void)loadTags;
-(IBAction)loadImage;

-(IBAction)confirmElement;
-(IBAction)cancelElement;

@end
