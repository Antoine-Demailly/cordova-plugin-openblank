/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVIntentAndNavigationFilter+OpenBlank.h"
#import <Cordova/CDV.h>

@implementation CDVIntentAndNavigationFilter (OpenBlank)




#pragma mark CDVPlugin

- (void)pluginInitialize
{
    if ([self.viewController isKindOfClass:[CDVViewController class]]) {
        [(CDVViewController*)self.viewController parseSettingsWithParser:self];
    }
}

- (BOOL)shouldOverrideLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL* url = [request URL];
    BOOL allowNavigationsPass = YES;
    
    NSString* indexPath = @"www/index.html";
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    
    // Ignore initial load
    if ([[url absoluteString] containsString:[bundlePath stringByAppendingPathComponent:indexPath]]) {
        return YES;
    }

    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            [[UIApplication sharedApplication] openURL:url];
            allowNavigationsPass = NO;
            break;
        }
        case UIWebViewNavigationTypeOther:
        {
            NSString* documentURL = [[request mainDocumentURL] absoluteString];
            
            //if they are the same this is a javascript href click
            if( [url.absoluteString isEqualToString:documentURL]) {
                [[UIApplication sharedApplication] openURL:url];
                return NO;
            }
            
            break;
        }
        default: {
            break;
        }
                
    }
    
    return allowNavigationsPass;
}

@end
