fun main() {
    var n = 5;
    var sum = 0;
    for (var i=0; i<n; ++i) {
        sum = sum + carre(i);
        print(sum);
    }
    print(sum / 9);
}

fun carre(n) {
    n * n;
}
