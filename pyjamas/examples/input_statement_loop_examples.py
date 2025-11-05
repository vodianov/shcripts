# User inputs
name = input("Enter your name: ")
age = int(input("Enter your age: "))

# Control statement (if-else)
if age >= 18:
    print(f"Hello {name}! You are eligible to vote.")
else:
    print(f"Hello {name}! You are not yet eligible to vote. You can vote in {18 - age} years.")

# For loop
print("Printing numbers from 1 to 5 using a for loop:")
for i in range(1, 6):
    print(i)

# While loop
num = int(input("Enter a number: "))
fact = 1
i = 1

while i <= num:
    fact *= i
    i += 1

print(f"The factorial of {num} is: {fact}")
