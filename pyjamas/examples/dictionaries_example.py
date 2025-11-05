# Creating a dictionary
my_dict = {'name': 'John', 'age': 30, 'city': 'New York'}

# Accessing values
print("Name:", my_dict['name'])
print("Age:", my_dict['age'])

# Adding a new key-value pair
my_dict['email'] = 'john@example.com'
print("Updated dictionary:", my_dict)

# Iterating through keys and values
for key, value in my_dict.items():
    print(f"{key}: {value}")
