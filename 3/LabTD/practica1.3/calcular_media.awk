BEGIN {
    total=0;
    num=1;
}

{
    total=total+$1;
    num=num+1;
}

END {
    media=total/num;
    print media;
}
