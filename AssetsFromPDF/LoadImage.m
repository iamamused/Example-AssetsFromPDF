//
//  LoadImage.m
//  AssetsFromPDF
//
//  Created by Jeffrey Sambells on 2012-03-02.
//

#import "LoadImage.h"
#import "NSThread+Blocks.h"

@implementation LoadImage

+ (void)LoadFromPDF:(NSString *)fileNameWithoutExtension size:(CGSize)size callback:(void (^)(UIImage *))callback  {
    
    [NSThread performBlockInBackground:^{

    
        // Determine if the device is retina.
        BOOL isRetina = [UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0;
        
        
        // Create a file manager so we can check if the image exists and store the image.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        // Define the formats for the image names (low and high res).
        NSString *path = @"rendered-%@.png";
        NSString *pathHigh = @"rendered-%@@2x.png";
        
        // Get the file name.
        NSString *file = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:( isRetina ? pathHigh : path ) , fileNameWithoutExtension]];
        
        UIImage *image;
        
        if ( ![fileManger fileExistsAtPath:file] ) {
            
            // Image doesn't exist so load the PDF and create it.
            
            // Get a reference to the PDF.
            NSString *pdfName = [NSString stringWithFormat:@"%@.pdf", fileNameWithoutExtension];
            CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)pdfName, NULL, NULL);
            CGPDFDocumentRef pdfDoc = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
            CFRelease(pdfURL);
            
            if (isRetina) {
                UIGraphicsBeginImageContextWithOptions(size, false, 0);	
            } else {
                UIGraphicsBeginImageContext( size );
            }
            
            // Load the first page. You could have multiple pages if you wanted.
            CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDoc, 1);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // PDF page drawing expects a lower-left coordinate system, 
            // flip the coordinate system before we start drawing.
            CGRect bounds = CGContextGetClipBoundingBox(context);
            CGContextTranslateCTM(context, 0, bounds.size.height);
            CGContextScaleCTM(context, 1.0, -1.0);
            
            // Save the graphics state.
            CGContextSaveGState(context);
            
            // CGPDFPageGetDrawingTransform provides an easy way to get the transform 
            // for a PDF page. It will scale down to fit, including any
            // base rotations necessary to display the PDF page correctly. 
            CGRect transformRect = CGRectMake(0, 0, size.width, size.height);
            CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, transformRect, 0, true);
            
            // And apply the transform.
            CGContextConcatCTM(context, pdfTransform);
            
            // Draw the page.
            CGContextDrawPDFPage(context, pdfPage);
            
            // Restore the graphics state.
            CGContextRestoreGState(context);
            
            // Generate the image.
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            // Store the PNG for next time.
            [UIImagePNGRepresentation(image) writeToFile:file atomically:YES];
            
            UIGraphicsEndImageContext();
            CGPDFDocumentRelease(pdfDoc);	
            
        } else {
            
            // Load the image from the file system.
            image = [UIImage imageWithContentsOfFile:file];
            
        }
    
        [[NSThread mainThread] performBlock:^{
            callback(image);
        }];
        
    }];}

@end
