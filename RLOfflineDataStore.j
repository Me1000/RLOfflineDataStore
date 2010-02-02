@implementation RLOfflineDataStore : CPObject
{
    CPString    _name;
    double      _size;
    id          _db;
    id          _delegate;
}

+ (BOOL)offlineDataStoreIsAvailable
{
    return !!window.openDatabase
}

- (id)initWithName:(CPString)aName delegate:(id)anObject
{
    _delegate = anObject;

    if ([RLOfflineDataStore offlineDataStoreIsAvailable])
        [CPException exceptionWithName:@"RLOfflineDataStore" reason:@"Offline storage is not supported for this browser." userInfo:nil];

    self = [super init];
    if (self)
    {
        _name = aName;
        _size = 1024 * 2000;
        
        _db = openDatabase('RCOfflineDataStore-' + _name, '1.0', _name, _size);

        if(!_db && [_delegate respondsToSelector:@selector(userDidRejectDatabase)])
            [_delegate userDidRejectDatabase];
        else if(!_db)
            [CPException exceptionWithName:@"RLOfflineDataStore" reason:@"Offline storage was rejected by the user." userInfo:nil];

        _db.transaction(function(_db){
                _db.executeSql( 'CREATE TABLE IF NOT EXISTS RLOfflineDataStore (key TEXT UNIQUE NOT NULL PRIMARY KEY, value TEXT NOT NULL)' );
        });
    }
    return self;
}

- (void)setValue:(CPString)aValue forKey:(CPString)aKey
{
    //there is probably a better way to do this
    _db.transaction(function(db){
        //if the key exists update it, if not it will fail quietly.
        db.executeSql("UPDATE RLOfflineDataStore SET value = ? WHERE key = ?",[aValue, aKey], function result(tx, rs){}, function anError(tx, err){});
        //if the key exists this will fail quietyl, if not it will add the key to the db.
        db.executeSql("INSERT INTO RLOfflineDataStore (key, value) VALUES (?, ?)", [aKey, aValue], function result(db, rs){}, function error(db, err){});
    });

    
}

- (void)getValueForKey:(CPString)aKey
{
    _db.transaction(function(db){
        db.executeSql("SELECT value FROM RLOfflineDataStore WHERE key=?",[aKey], function result(text, result){[self _parseResults:result];}, function anError(text, theError){});
    });
}

- (void)removeValueForKey:(CPString)aKey
{
    _db.transaction(function(db){
        db.executeSql("DELETE FROM RLOfflineDataStore WHERE key=?",[aKey], function result(text, result){}, function anError(text, theError){});
    });

}

- (void)_parseResults:(id)results
{
    if(results.rows.length > 0)
        var returnValue = results.rows.item(0).value;
    else
        var returnValue = nil;

    [_delegate didReciveData:returnValue];
}

@end