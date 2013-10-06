//
//  StyleTableViewController.m
//  Release
//
//  Created by Miguel Garcia-Santamarina Armesto on 7/23/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "StyleTableViewController.h"


@implementation StyleTableViewController

@synthesize picker, bStyleBold, bStyleItalic, tfSize, bTextColor, bAlignLeft, bAlignRight, bAlignCenter, bAlignJustify, bDecorationOver, bDecorationUnder, bDecorationThrough, bBackgroundColor, bBackgroundImage, maFamilies, maStyles, maImport, selectedTextColor, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    maStyles = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++) {
        [maStyles addObject:@""];
    }
    
    [maStyles addObject:[NSNull null]];
    
    //0: Font family
    //1: Text color
    //2: Background color
    //3: Background image
    
    picker.delegate = self;
    tfSize.delegate = self;

    [self loadFontFamilies];
    [self initializeStyles];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)importStyles:(NSMutableArray *)stylesArray
{
    maImport = [[NSMutableArray alloc] init];
    for (int i=0; i<[stylesArray count]; i++) {
        [maImport addObject:[stylesArray objectAtIndex:i]];
    }
}

- (void)initializeStyles
{
    NSArray *tempArray = [[maImport objectAtIndex:0] componentsSeparatedByString: @","];
    [maFamilies replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@ - %@",[tempArray objectAtIndex:0],[maFamilies objectAtIndex:1]]];
    
    if ([[maImport objectAtIndex:1] isEqualToString:@"bold"] || [[maImport objectAtIndex:1] isEqualToString:@"bolder"] || [[maImport objectAtIndex:1] intValue] >= 600) {
        bStyleBold.selected = YES;
    }
    
    if ([[maImport objectAtIndex:2] isEqualToString:@"italic"] || [[maImport objectAtIndex:1] isEqualToString:@"oblique"]) {
        bStyleItalic.selected = YES;
    }
    
    tempArray = [[maImport objectAtIndex:3] componentsSeparatedByString: @"p"];
    tfSize.text = [tempArray objectAtIndex:0];

    NSArray *colorComponents = [[maImport objectAtIndex:4] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(,)"]];
    UIColor *color = nil;
    
    if ([colorComponents count] == 5) {
        color = [UIColor colorWithRed:[[colorComponents objectAtIndex:1] floatValue]/255.0 green:[[colorComponents objectAtIndex:2] floatValue]/255.0  blue:[[colorComponents objectAtIndex:3] floatValue]/255.0  alpha:1.0];
    }else{
          color = [UIColor colorWithRed:[[colorComponents objectAtIndex:1] floatValue]/255.0 green:[[colorComponents objectAtIndex:2] floatValue]/255.0  blue:[[colorComponents objectAtIndex:3] floatValue]/255.0  alpha:[[colorComponents objectAtIndex:4] floatValue]/255.0];
    }
    
    UIImage *coloredImg = [self dyeImage:color];
    [bTextColor setImage:coloredImg forState:UIControlStateNormal];
    
   switch ([[maImport objectAtIndex:5] characterAtIndex:0]) {
        case 'l':
            bAlignLeft.selected = YES;
            break;
        case 'r':
            bAlignRight.selected = YES;
            break;
        case 'c':
            bAlignCenter.selected = YES;
            break;
        case 'j':
            bAlignJustify.selected = YES;
            break;
            
        default:
            bAlignLeft.selected = YES;
            break;
    }
    
    switch ([[maImport objectAtIndex:6] characterAtIndex:0]) {
        case 'o':
            bDecorationOver.selected = YES;
            break;
        case 'l':
            bDecorationThrough.selected = YES;
            break;
        case 'u':
            bDecorationUnder.selected = YES;
            break;
    }
    if ([[maImport objectAtIndex:7] isEqualToString:@"transparent"] ) {
        [bBackgroundColor setImage:[UIImage imageNamed:[NSString stringWithFormat:@"none.png"]] forState:UIControlStateNormal];
    }else{
        colorComponents = [[maImport objectAtIndex:7] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(,)"]];
        color = nil;
    
        if ([colorComponents count] == 5) {
            color = [UIColor colorWithRed:[[colorComponents objectAtIndex:1] floatValue]/255.0 green:[[colorComponents objectAtIndex:2] floatValue]/255.0  blue:[[colorComponents objectAtIndex:3] floatValue]/255.0  alpha:1.0];
        }else{
            color = [UIColor colorWithRed:[[colorComponents objectAtIndex:1] floatValue]/255.0 green:[[colorComponents objectAtIndex:2] floatValue]/255.0  blue:[[colorComponents objectAtIndex:3] floatValue]/255.0  alpha:[[colorComponents objectAtIndex:4] floatValue]/255.0];
        }
    
        coloredImg = [self dyeImage:color];
        [bBackgroundColor setImage:coloredImg forState:UIControlStateNormal];
    }
    
    if (![[maImport objectAtIndex:8] isEqualToString:@"none"]) {
        NSArray *imagePath = [[maImport objectAtIndex:8] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
        [bBackgroundImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[imagePath objectAtIndex:1]]]] forState:UIControlStateNormal];
    }

}

- (UIImage*)dyeImage:(UIColor *)color
{
    // load the image
    NSString *name = @"iphone_icon.png";
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tfSize resignFirstResponder];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(IBAction)selectButton:(UIButton*)sender
{
    if (![sender isSelected]) {
        if (sender == bAlignLeft || sender == bAlignRight || sender == bAlignCenter || sender == bAlignJustify) {
            bAlignLeft.selected = NO;
            bAlignRight.selected = NO;
            bAlignCenter.selected = NO;
            bAlignJustify.selected = NO;
        }
        if (sender == bDecorationOver || sender == bDecorationUnder || sender == bDecorationThrough) {
            bDecorationOver.selected = NO;
            bDecorationUnder.selected = NO;
            bDecorationThrough.selected = NO;
        }
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
    
}

-(IBAction)selectBackgroundImage:(UIButton*)sender
{
    ImagePickerView *ipView =  [[ImagePickerView alloc] initWithFrame:CGRectMake(160, 240, 0, 0) fromStyleTable:YES];
    [self.tableView.window addSubview:ipView];
    ipView.delegate = self;
}

-(IBAction)removeBackgroundImage:(UIButton *)sender
{
    [maStyles replaceObjectAtIndex:3 withObject:@"none"];
    [bBackgroundImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"none.png"]] forState:UIControlStateNormal];
}

-(IBAction)removeBackgroundColor:(UIButton *)sender
{
    [maStyles replaceObjectAtIndex:2 withObject:@"transparent"];
    [bBackgroundColor setImage:[UIImage imageNamed:[NSString stringWithFormat:@"none.png"]] forState:UIControlStateNormal];
}


-(NSString*)colorToHex:(UIColor*)color{
    
    CGColorRef colorref = [color CGColor];
    
    const CGFloat *components = CGColorGetComponents(colorref);
    
    NSString *hexString = @"#";
    int hexValue = 0;
     
    for (int i=0; i<3; i++) {
        if (components[i] == 0) {
            hexString = [NSString stringWithFormat:@"%@00", hexString];
        } else {
            hexValue = 0xFF*components[i];
            if (hexValue <16) {
                hexString = [NSString stringWithFormat:@"%@0%x", hexString, hexValue];
            }else{
                hexString = [NSString stringWithFormat:@"%@%x", hexString, hexValue];
            }
        }
    }
    
    return hexString;
}

-(IBAction)confirmStyle{
    
    NSString *styleString = @"";
    
    if (![[maStyles objectAtIndex:0] isEqualToString:@""]) {
        styleString = [NSString stringWithFormat:@"%@element.style.fontFamily='%@';",styleString, [maStyles objectAtIndex:0]];
    }
    
    if ([bStyleBold isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.fontWeight='bold';",styleString];
    }else{
        styleString = [NSString stringWithFormat:@"%@element.style.fontWeight='normal';",styleString];
    }
    
    if ([bStyleItalic isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.fontStyle='italic';",styleString];
    }else{
        styleString = [NSString stringWithFormat:@"%@element.style.fontStyle='normal';",styleString];
    }
    
    if (![tfSize.text isEqualToString:@""]) {
        styleString = [NSString stringWithFormat:@"%@element.style.fontSize='%@px';",styleString, tfSize.text];
    }
    
    if (![[maStyles objectAtIndex:1] isEqualToString:@""]) {
        styleString = [NSString stringWithFormat:@"%@element.style.color='%@';",styleString, [maStyles objectAtIndex:1]];
    }
    
    if ([bAlignLeft isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textAlign='left';",styleString];
    }

    if ([bAlignRight isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textAlign='right';",styleString];
    }

    if ([bAlignCenter isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textAlign='center';",styleString];
    }

    if ([bAlignJustify isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textAlign='justify';",styleString];
    }
    
    if ([bDecorationOver isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textDecoration='overline';",styleString];
    }
    
    if ([bDecorationUnder isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textDecoration='underline';",styleString];
    }
    
    if ([bDecorationThrough isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textDecoration='line-through';",styleString];
    }
    
    if (![bDecorationOver isSelected] && ![bDecorationUnder isSelected] && ![bDecorationThrough isSelected]) {
        styleString = [NSString stringWithFormat:@"%@element.style.textDecoration='none';",styleString];
    }

    if (![[maStyles objectAtIndex:2] isEqualToString:@""]) {
        styleString = [NSString stringWithFormat:@"%@element.style.backgroundColor='%@';",styleString, [maStyles objectAtIndex:2]];
    }
    
    if ([maStyles objectAtIndex:3] != [NSNull null]) {
        if ([[maStyles objectAtIndex:3] isKindOfClass:[NSURL class]]) {
            styleString = [NSString stringWithFormat:@"%@element.style.backgroundImage='url(%@)';"
                "element.style.backgroundRepeat='no-repeat';"
                "element.style.backgroundSize='cover';", styleString, [maStyles objectAtIndex:3]];
        }else{
            if ([[maStyles objectAtIndex:3] isKindOfClass:[NSString class]]) {
                styleString = [NSString stringWithFormat:@"%@element.style.backgroundImage='none';", styleString];
            }else{
                NSData *imgData = UIImageJPEGRepresentation([maStyles objectAtIndex:3], 0.1);
                NSString *imgB64 = [[imgData base64Encoding] pngDataURIWithContent];
        
                styleString = [NSString stringWithFormat:@"%@element.style.backgroundImage='url(%@)';"
                    "element.style.backgroundRepeat='no-repeat';"
                    "element.style.backgroundSize='cover';", styleString, imgB64];
            }
        }
    } 
    [self.delegate styleTableViewControllerDidConfirm:self withString:styleString];
    
}

-(IBAction)cancelStyle{
    [self.delegate styleTableViewControllerDidCancel:self];
    
}

#pragma mark - Picker view delegate

- (void)loadFontFamilies
{
    maFamilies = [[NSMutableArray alloc] initWithObjects: @"Default", @"Current font", @"American Typewriter", @"Arial", @"Baskerville", @"Copperplate", @"Courier New", @"Georgia", @"Gill Sans", @"Hoefler Text", @"Futura", @"Lucida Grande", @"Marker Felt", @"Optima", @"Trebuchet MS", @"Verdana", @"Palatino", @"Papyrus", @"Zapf Dingbats", @"Zapfino", nil];

    [picker selectRow:1 inComponent:0 animated:NO];
        
    [super viewDidUnload];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 1) {
        [maStyles replaceObjectAtIndex:0 withObject:@""];
    } else {
        if (row == 0) {
            [maStyles replaceObjectAtIndex:0 withObject:@"Times"];
        } else {
            [maStyles replaceObjectAtIndex:0 withObject:[maFamilies objectAtIndex:row]];
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [maFamilies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [maFamilies objectAtIndex:row];
}

#pragma mark - Color picker view controller delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SelectTextColor"] || [segue.identifier isEqualToString:@"SelectBackgroundColor"])
	{
        if ([segue.identifier isEqualToString:@"SelectTextColor"]){
            selectedTextColor = YES;
        } else {
            selectedTextColor = NO;
        }
		ColorPickerViewController *colorPickerViewController = 
        segue.destinationViewController;
		
		colorPickerViewController.delegate = self;
	}
}

- (void)colorPickerViewControllerDidConfirm:(ColorPickerViewController *)controller withColor:(UIColor *)color;
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *coloredImg = [self dyeImage:color];
        
    if (selectedTextColor) {
        [bTextColor setImage:coloredImg forState:UIControlStateNormal];
        [maStyles replaceObjectAtIndex:1 withObject:[self colorToHex:color]];
        
    } else {
        [bBackgroundColor setImage:coloredImg forState:UIControlStateNormal];
        [maStyles replaceObjectAtIndex:2 withObject:[self colorToHex:color]];
    }

}

- (void)colorPickerViewControllerDidCancel:(ColorPickerViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image picker view controller delegate

-(void)goBackFromImagePickerView
{       
    
}

- (void)goToImagePicker:(BOOL)fromAlbum
{       
    if (fromAlbum) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(119/255.0f) green:(139/255.0f) blue:(168/255.0f) alpha:0.1];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(119/255.0f) green:(139/255.0f) blue:(168/255.0f) alpha:0.1];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{    
    [bBackgroundImage setImage:image forState:UIControlStateNormal];
    [maStyles replaceObjectAtIndex:3 withObject:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{       
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)returnImageURL:(NSURL *)withURL
{
    [maStyles replaceObjectAtIndex:3 withObject:withURL];
    [bBackgroundImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[maStyles objectAtIndex:3]]] forState:UIControlStateNormal];
}

@end
