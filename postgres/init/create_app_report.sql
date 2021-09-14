create table if not exists app_report(
    date date, 
    srcip varchar(150), 
    app varchar(150), 
    appcate varchar(150), 
    act varchar(150), 
    bytes int
); 