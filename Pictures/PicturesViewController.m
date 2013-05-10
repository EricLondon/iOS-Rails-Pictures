//
//  PicturesViewController.m
//  Pictures
//
//  Created by Eric London on 1/22/13.
//  Copyright (c) 2013 EricLondon. All rights reserved.
//

#import "PicturesViewController.h"
#import "PicturesCollectionViewCell.h"
#import "AFJSONRequestOperation.h"

@interface PicturesViewController ()

@end

@implementation PicturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // fetch images JSON

    // URL/Request
    NSString *imagesUrl = [NSString stringWithFormat:@"http://pics.ericlondon.com/images.json"];
    NSURL *url = [NSURL URLWithString:imagesUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];

    // request parameters
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    // AF json request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            [self.collectionView performBatchUpdates:^{
                                
                NSArray *visibleCells = [self.collectionView visibleCells];
                
                for (NSInteger i=0; i <[visibleCells count]; i++) {

                    PicturesCollectionViewCell *cell = visibleCells[i];
                    
                    NSString *thumbPath = [NSString stringWithFormat:@"http://pics.ericlondon.com%@", JSON[i][@"thumb_path"]];
                    NSURL *thumbPathURL = [NSURL URLWithString:thumbPath];
                    NSData *imageData = [NSData dataWithContentsOfURL:thumbPathURL];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    cell.pictureImageView.image = image;
                    
                }

            } completion:nil];            

        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"ERROR: %@", error);
        }
    ];

    [operation start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicturesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pictureCell" forIndexPath:indexPath];
        
    return cell;
}

@end
