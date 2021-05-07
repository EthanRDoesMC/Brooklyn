#import "BLRootViewController.h"
#import "ChatViewController.h"
#import "LogViewController.h"
#import "ExportLogsViewController.h"
#import "BLOnboardingViewController.h"
@interface BLRootViewController ()
@property (nonatomic, strong) NSMutableArray * chats;
@property (nonatomic, strong) UITabBarController * tbc;
@end

@implementation BLRootViewController





-(void)reloadChats {
    
    self.navigationItem.prompt = @"Reloading chats";
    if ([BrooklynBridge riseAndShineIMDaemon]) {
        _chats = [[NSMutableArray alloc] initWithArray:[BrooklynBridge conversationArray]];
        //_numberOfChats = [[IMChatRegistry sharedInstance] numberOfExistingChats];
        self.navigationItem.prompt = nil;
        
    }
    else {
        self.navigationItem.prompt = @"Failed to load chats in time!";
    }
    
}

- (void)loadView {
    [[BrooklynBridge sharedBridge] playLoadingChime];
    //    [self setDefinesPresentationContext:YES];
    //    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self reloadChats];
    [super loadView];
    self.title = @"Brooklyn";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log" style:UIBarButtonItemStylePlain target:self action:@selector(viewLog:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
    [self.tableView reloadData];
    //self.navigationItem.prompt = nil;
    //    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //    []
    //    [self.tableView setSeparatorEffect:<#(API_AVAILABLE(ios(8.0)) UIVisualEffect *)#>]
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addButtonTapped:) name:@"BLLaunchOnboarding" object:nil];
}


-(void)viewDidLoad {
    [super viewDidLoad];
    [self reloadChats];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIBlurEffect * be = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * vev = [[UIVisualEffectView alloc] initWithEffect:be];
    self.tableView.backgroundView = vev;
    self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:be];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[BrooklynBridge sharedBridge] stopLoadingChime];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incomingMessage:) name:@"__kIMChatMessageReceivedNotification" object:nil];
    
}
-(void)incomingMessage:(NSNotification *)notif {
    self.navigationItem.prompt = @"Incoming message";
    NSLog(@"%@ | %@ | %@", notif.name, notif.object, notif.userInfo);
}
-(void)viewDidAppear:(BOOL)animated {
    [self reloadChats];
    [super viewDidAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addButtonTapped:(id)sender {
    BLOnboardingViewController * newc = [[BLOnboardingViewController alloc] initWithNibName: @"BLOnboardingViewController" bundle:nil];
    [self presentViewController:newc animated:YES completion:nil];
}

-(void)viewLog:(id)sender {
    LogViewController * logv = [[LogViewController alloc] initWithNibName: @"LogViewController" bundle:nil];
    ExportLogsViewController * lev = [[ExportLogsViewController alloc] initWithNibName: @"ExportLogsViewController" bundle:nil];
    self.tbc = [UITabBarController new];
    logv.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0];
    lev.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:1];
    [self.tbc setViewControllers:@[logv, lev]];
    
    [self.navigationController pushViewController:self.tbc animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CKConversation * chat = _chats[indexPath.row];
    if (chat.isGroupConversation) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:chat.thumbnail];
        cell.accessoryView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:chat.recipient.transcriptContactImage];
    }
    if (chat.hasDisplayName) {
        cell.textLabel.text = chat.displayName;
    } else {
        cell.textLabel.text = chat.name;
    }
    cell.detailTextLabel.text = chat.previewText;
    if (chat.outgoingBubbleColor) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.10 green: 0.51 blue: 0.99 alpha: 1.00];
    } else {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.26 green: 0.80 blue: 0.28 alpha: 1.00];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BrooklynBridge sharedBridge] playLoadingChime];
    self.navigationItem.prompt = @"Deleting chat";
    //[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    CKConversation *chat3 = _chats[indexPath.row];
    [chat3 deleteAllMessagesAndRemoveGroup];
    [_chats removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.navigationItem.prompt = nil;
    [[BrooklynBridge sharedBridge] stopLoadingChime];
}



#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BrooklynBridge sharedBridge] playLoadingChime];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CKConversation * chat2 = _chats[indexPath.row];
    [chat2 loadAllMessages];
    ChatViewController * cvc = [[ChatViewController alloc] initWithConversation:chat2];
    [self.navigationController pushViewController:cvc animated:YES];
    [[BrooklynBridge sharedBridge] stopLoadingChime];
}



@end
