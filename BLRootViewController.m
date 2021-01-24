#import "BLRootViewController.h"
#import "ChatViewController.h"
@interface BLRootViewController ()
//@property (nonatomic, strong) NSMutableArray * objects;
@end

@implementation BLRootViewController

- (void)loadView {
//    [self setDefinesPresentationContext:YES];
//    [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
	[super loadView];
    [BrooklynBridge riseAndShineIMDaemon];
    [BrooklynBridge conversationArray];
	//_objects = [NSMutableArray array];

	self.title = @"Brooklyn";
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] _setBackgroundStyle:1];
    [self.tableView reloadData];
//    [self.tableView setBackgroundColor:[UIColor clearColor]];
//    []
//    [self.tableView setSeparatorEffect:<#(API_AVAILABLE(ios(8.0)) UIVisualEffect *)#>]
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    UIBlurEffect * be = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * vev = [[UIVisualEffectView alloc] initWithEffect:be];
    self.tableView.backgroundView = vev;
    self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:be];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addButtonTapped:(id)sender {
    BLNewChatViewController * newc = [[BLNewChatViewController alloc] initWithNibName: @"BLNewChatViewController" bundle:nil];
    [self.navigationController pushViewController:newc animated:YES];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[IMChatRegistry sharedInstance] numberOfExistingChats];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ChatCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

    CKConversation * chat = [BrooklynBridge conversationArray][indexPath.row];
    cell.textLabel.text = chat.name;
	cell.detailTextLabel.text = chat.description;
    if (chat.outgoingBubbleColor) {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.10 green: 0.51 blue: 0.99 alpha: 1.00];
    } else {
        cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.26 green: 0.80 blue: 0.28 alpha: 1.00];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	//[_objects removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}



#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    CKConversation * chat2 = [BrooklynBridge conversationArray][indexPath.row];
    ChatViewController * cvc = [[ChatViewController alloc] initWithConversation:chat2];
    [self.navigationController pushViewController:cvc animated:YES];
}



@end
