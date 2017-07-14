
#import "MerryPhotoViewer.h"

@implementation MerryPhotoViewer

RCT_EXPORT_MODULE()

- (NSDictionary *)constantsToExport {
  return @{@"SHORT" : [NSNumber numberWithDouble:1]};
}
- (UIViewController *)visibleViewController:(UIViewController *)rootViewController {
  if (rootViewController.presentedViewController == nil) {
    return rootViewController;
  }
  if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController =
        (UINavigationController *)rootViewController.presentedViewController;
    UIViewController *lastViewController = [[navigationController viewControllers] lastObject];

    return [self visibleViewController:lastViewController];
  }
  if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController *tabBarController =
        (UITabBarController *)rootViewController.presentedViewController;
    UIViewController *selectedViewController = tabBarController.selectedViewController;

    return [self visibleViewController:selectedViewController];
  }

  UIViewController *presentedViewController =
      (UIViewController *)rootViewController.presentedViewController;

  return [self visibleViewController:presentedViewController];
}

- (void)_show:(NSMutableArray *)photos {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *ctrl =
        [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    NYTPhotosViewController *photosViewController =
        [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:nil];
    [ctrl presentViewController:photosViewController animated:YES completion:nil];
  });
}

RCT_EXPORT_METHOD(show : (NSMutableArray *)photos { [self _show:photos]; });
@end
