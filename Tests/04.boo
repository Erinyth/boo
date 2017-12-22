fun main() {
    for (var i = 2; i < 50; ++i) {
        if (isPrime(i))
            print(i);
    }
}

fun isPrime(n) {
    var prime = 1;
    for (var i = 2; 
        prime && i < n;
        ++i) {
        if (n % i == 0) {
            prime = 0;
        }
    }
    prime;
}
