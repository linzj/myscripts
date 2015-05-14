(function () {
    var downloads = document.querySelectorAll('input[name*=btdownurl]');
    for (var i in downloads) {
        var now = downloads[i];
        if (typeof(now.value) == "undefined") {
            break;
        }
        console.log(now.value);
        var name = now.previousSibling.previousSibling;
        console.log(name.value);
    }
})()
