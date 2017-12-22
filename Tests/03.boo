fun main() {
    var x = 42;
    print(x);
    for (var i = 1; i <= 5; ++i)
        print(factorial(i)); 
}

fun factorial(n) {
    if (n < 1) {
        1;
    }
    else {
        n * factorial(n - 1);
    }
}
