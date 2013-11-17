/*
 Nestopia for iOS
 Copyright (c) 2013, Jonathan A. Zdziarski
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 */

#import "NestopiaAppDelegate.h"
#import "GamesViewController.h"
#import "SettingsViewController.h"

@implementation NestopiaAppDelegate {
    UIWindow *window;
    
    UITabBarController *tabBarController;
    GamesViewController *gamesViewController;
	GamesViewController *savedGamesViewController;
    GamesViewController *favoritesViewController;
	SettingsViewController *settingsViewController;
    UINavigationController *settingsNavigationController;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [self setupViewControllers];
    
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.rootViewController = tabBarController;
	[window makeKeyAndVisible];
}

- (void)setupViewControllers {
	gamesViewController = [[GamesViewController alloc] init];
    
    savedGamesViewController = [[GamesViewController alloc] init];
    savedGamesViewController.saved = YES;
    
    favoritesViewController = [[GamesViewController alloc] init];
    favoritesViewController.favorite = YES;
    
    settingsViewController = [[SettingsViewController alloc] init];
    settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];

    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[ gamesViewController, savedGamesViewController, favoritesViewController, settingsNavigationController ];
}

@end
