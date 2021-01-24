//
//  ChatViewController.m
//  brooklyn
//
//  Created by EthanRDoesMC on 1/5/21.
//

#import "ChatViewController.h"
#import "SendMessageController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIBlurEffect * be = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * vev = [[UIVisualEffectView alloc] initWithEffect:be];
    self.tableView.backgroundView = vev;
    self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:be]; 
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)addButtonTapped:(id)arg1 {
    SendMessageController * smc = [[SendMessageController alloc] initWithNibName:@"SendMessageController" bundle:nil];
    smc.chat = self.chat;
    [self.navigationController pushViewController:smc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Cell2Identifier = @"ChatViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell2Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell2Identifier];
    }
    
    cell.textLabel.text = @"open transcript";
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(id)initWithConversation:(CKConversation *)chat {
    self.chat = chat;
    return [super init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    CKTranscriptController * tc = [[CKTranscriptController alloc] init];
    [tc setConversation:self.chat];
    [self.chat.chat loadMessagesBeforeDate:[NSDate date] limit:100 loadImmediately:NO];
    
    [self presentViewController:tc animated:YES completion:nil];
}

@end
