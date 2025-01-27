fn factorial(n: i32) -> i32 {
    let mut result = 1;

    for i in 1..=n {
        result *= i;
    }

    result
}

fn main() {
    let number = 5;

    let answer = factorial(number);

    println!("factorial({}) = {}", number, answer);
}

