BEGIN{
    suma=0;
    total=0;
}
{
    total=total+1;
    tiempo=$2;
    suma=suma+tiempo;
}

END {
    calculo=suma/total;
    print calculo;
}
