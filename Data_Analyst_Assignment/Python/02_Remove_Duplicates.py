def remove_duplicates(input_string):
    """
    Take a string and remove duplicate characters using a loop.
    Returns a new string with characters in their original order.
    """
    if not isinstance(input_string, str):
        return "Invalid input. Please provide a string."
        
    result = ""
    
    # Loop through every character in the string
    for char in input_string:
        # Check if the character is not already in the result string
        if char not in result:
            result += char
            
    return result

if __name__ == "__main__":
    # Test cases
    test_cases = [
        "hello world",
        "aabbccddeeff",
        "programming",
        "PlatinumRx",
        "data analyst"
    ]
    
    print("Testing Remove Duplicates:")
    for test in test_cases:
        result = remove_duplicates(test)
        print(f"Original: '{test}' | Unique: '{result}'")
