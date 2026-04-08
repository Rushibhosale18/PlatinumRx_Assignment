def convert_minutes(total_minutes):
    """
    Convert integer minutes into X hrs Y minutes format.
    """
    if not isinstance(total_minutes, int) or total_minutes < 0:
        return "Invalid input. Please provide a non-negative integer."

    # Using integer division to get the total hours
    hours = total_minutes // 60
    
    # Using modulo operator to get the remaining minutes
    remaining_minutes = total_minutes % 60
    
    return f"{hours} hrs {remaining_minutes} minutes"

if __name__ == "__main__":
    # Test cases
    test_cases = [130, 60, 45, 0, 1500]
    
    print("Testing Time Converter:")
    for minutes in test_cases:
        result = convert_minutes(minutes)
        print(f"{minutes} minutes = {result}")
