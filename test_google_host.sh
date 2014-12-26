#74.125.200.1
test_main ()
{
    curl --connect-timeout 20 -H 'HOST: www.google.com'  -X GET https://$1 -w %{http_code} -o /dev/null -s | grep 200 >/dev/null
}

test_1 ()
{
    declare -a my_array
    COUNT=1
    OTHER=$1
    while [ $COUNT -ne 255 ]
        do
            test_main $OTHER.$COUNT &
            my_array[$COUNT]=$!
            ((++COUNT))
        done
    COUNT=1
    while [ $COUNT -ne 255 ]
        do
            wait ${my_array[$COUNT]}
            if [ $? -eq 0 ]
                then
                echo $OTHER.$COUNT is good
            fi
            ((++COUNT))
        done
}

test_2 ()
{
    COUNT_2=1
    OTHER_2=$1
    while [ $COUNT_2 -ne 255 ]
        do
            test_1 $OTHER_2.$COUNT_2
            ((++COUNT_2))
        done
}

test_2 74.124
