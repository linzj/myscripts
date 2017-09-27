export IFS=""


doDownload ()
{

    #while ! wget -T 6  --limit-rate=1700k --load-cookies cookies.txt -U 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36' $1 -c -O "$2"
    #while ! curl  -L --limit-rate 300k -c cookies.txt -b cookies.txt -A 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36' $1 -C - -o "$2"
    #while ! aria2c -m 0 -t 5 --async-dns-server=8.8.8.8 --load-cookies cookies.txt -U 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36' $1 -c --file-allocation=trunc -o $2
    while ! aria2c -m 0 -t 5 -s 10 -x 5 -k 1048576 --async-dns-server=8.8.8.8 --load-cookies cookies.txt -U 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36' $1 -c --file-allocation=trunc -o $2
        do
            sleep 5
            rm $2
        done

}

cat downloadList | while read -r site
    do
        if ! read -r name
        then
            echo failed to read name
            exit 1
        fi

        doDownload  $site $name 
    done
