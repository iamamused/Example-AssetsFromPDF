//
//  ViewController.m
//
//  Created by Jeffrey Sambells on 2012-03-02.
//

#import "ViewController.h"
#import "LoadImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setContentMode:UIViewContentModeCenter];
    [self.view addSubview:imageView];
    
    [LoadImage LoadFromPDF:@"apple_logo" size:CGSizeMake(100.0f,100.0f) callback:^(UIImage *image){
        [imageView setImage:image];
    }];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
