# sort_array.py

import sys
import json
import sort_module

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 sort_array.py '[array_to_sort]'")
        sys.exit(1)
    
    try:
        array = json.loads(sys.argv[1])
        if not isinstance(array, list) or not all(isinstance(x, (int, float)) for x in array):
            raise ValueError("Input must be a list of numbers.")
    except json.JSONDecodeError:
        print("Error: Unable to parse input. Ensure it is a valid JSON list.")
        sys.exit(1)
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
    
    # Sort the array
    sorted_array = sort_module.sort_array(array)
    print(f"Sorted array: {sorted_array}")

if __name__ == "__main__":
    main()

