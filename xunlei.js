(function () {
    function DownloadRecord(url) {
        this.url_ = url;
        this.name_ = null;
    }
    var downloads = document.querySelectorAll('input[name*=btdownurl]');
    var records = []
    for (var i in downloads) {
        var now = downloads[i];
        if (typeof(now.value) == "undefined") {
            break;
        }
        records.push(new DownloadRecord(now.value));
    }
    var names = document.querySelectorAll('a.w_title_open');
    // ignore the first entry
    for (var i = 1; i < names.length; ++i) {
        var name = names[i];
        var nameString = name.text;
        records[i - 1].name_ = nameString;
    }
    var html = document.documentElement;
    html.removeAttribute('unselectable');
    html.style = '-webkit-user-select: yes';
    var body = document.body
    myroot = document.createElement('div');
    body.appendChild(myroot);
    for (var i in records) {
        var record = records[i];
        if (record.name_ == null) {
            break;
        }
        var url = document.createElement('div');
        url.appendChild(document.createTextNode(record.url_));
        var name = document.createElement('div');
        name.appendChild(document.createTextNode(record.name_));
        myroot.appendChild(url);
        myroot.appendChild(name);
    }
})()
