//
//  LoadImage.h
//  AssetsFromPDF
//
//  Created by Jeffrey Sambells on 2012-03-02.
//

#import <Foundation/Foundation.h>

@interface LoadImage : NSObject

+ (void)LoadFromPDF:(NSString *)fileNameWithoutExtension size:(CGSize)size callback:(void (^)(UIImage *))callback;

@end
