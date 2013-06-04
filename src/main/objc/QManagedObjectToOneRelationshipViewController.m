//
// QManagedObjectToOneRelationshipViewController.m
//
// © Reaction Software Inc., 2013
//


#import "QManagedObjectToOneRelationshipViewController.h"
#import "NSObject+QEditor.h"
#import "NSManagedObject+QEditor.h"

@interface QManagedObjectToOneRelationshipViewController ()

@property (nonatomic, strong) NSIndexPath *checkedIndexPath;

@end

@implementation QManagedObjectToOneRelationshipViewController
{
    NSIndexPath *_checkedIndexPath;
    NSManagedObject *__weak _managedObject;
    NSString *_relationshipName;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.checkedIndexPath = [self.fetchedResultsController indexPathForObject:[_managedObject valueForKey:_relationshipName]];
}

#pragma mark - UITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"-[%@ %@] not supported", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![indexPath isEqual:_checkedIndexPath])
    {
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [_managedObject setValue:object forKey:_relationshipName];
        self.checkedIndexPath = indexPath;
    }
}

#pragma mark - QCoreDataTableViewController

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [super configureCell:cell atIndexPath:indexPath];
    if ([indexPath isEqual:_checkedIndexPath])
        [self selectTableViewCell:cell];
}

#pragma mark - QManagedObjectToOneRelationshipViewController

- (id)initWithTitle:(NSString *)aTitle object:(NSManagedObject *)object relationshipName:(NSString *)relationshipName
{
    if ((self = [super initWithStyle:UITableViewStyleGrouped]))
    {
        NSEntityDescription *sourceEntity = [object entity];
        NSEntityDescription *relationshipEntity = [[[sourceEntity relationshipsByName] objectForKey:relationshipName] destinationEntity];
        
        self.entityName = [relationshipEntity name];
        self.title = aTitle;
        
        _managedObject = object;
        _relationshipName = relationshipName;
        
        // Setup edit button in navigation controller
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    }
    return self;
}

- (void)setCheckedIndexPath:(NSIndexPath *)checkedIndexPath
{
    [self deselectTableViewCell:[self.tableView cellForRowAtIndexPath:_checkedIndexPath]];
    [self selectTableViewCell:[self.tableView cellForRowAtIndexPath:checkedIndexPath]];
    _checkedIndexPath = checkedIndexPath;
}

- (void)selectTableViewCell:(UITableViewCell *)cell
{
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [[cell textLabel] setTextColor:[UIColor colorWithRed:0.318f green:0.4f blue:0.569f alpha:1.0]];
}

- (void)deselectTableViewCell:(UITableViewCell *)cell
{
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [[cell textLabel] setTextColor:[UIColor darkTextColor]];
}

- (void)addButtonPressed:(id)sender
{
    NSManagedObject *newObject = [self createNewObject];
    
    // TODO: control the order of the new object in the list?
    [self presentEditorViewControllerForManagedObject:newObject];
}

- (void)presentEditorViewControllerForManagedObject:(NSManagedObject *)object
{
    QObjectEditorViewController *objectEditor = [object objectEditorViewController];
    objectEditor.delegate = self;
    objectEditor.showCancelButton = YES;
    objectEditor.showDoneButton = YES;
    objectEditor.style = QObjectEditorViewStyleForm;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objectEditor];
    [self presentViewController:navigationController animated:YES completion:^{
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }];
}

#pragma mark QObjectEditorViewControllerDelegate

- (void)objectEditorViewControllerDidEnd:(QObjectEditorViewController *)viewController cancelled:(BOOL)cancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (cancelled)
        [self.managedObjectContext deleteObject:(NSManagedObject *)viewController.editedObject];
    [self saveManagedObjectContext];
}

@end
