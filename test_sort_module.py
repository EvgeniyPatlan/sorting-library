import unittest
import sort_module

class TestSortModule(unittest.TestCase):
    def test_sorted_array(self):
        array = [1, 2, 3, 4, 5]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [1, 2, 3, 4, 5])

    def test_unsorted_array(self):
        array = [5, 2, 9, 1, 5, 6]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [1, 2, 5, 5, 6, 9])

    def test_array_with_negative_numbers(self):
        array = [3, -1, 4, -2, 0]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [-2, -1, 0, 3, 4])

    def test_empty_array(self):
        array = []
        result = sort_module.sort_array(array)
        self.assertEqual(result, [])

    def test_single_element_array(self):
        array = [42]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [42])

    def test_array_with_duplicates(self):
        array = [3, 3, 3, 3, 3]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [3, 3, 3, 3, 3])

    def test_mixed_positive_and_negative_numbers(self):
        array = [10, -1, -5, 4, 0, -10]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [-10, -5, -1, 0, 4, 10])

    def test_large_array(self):
        array = [i for i in range(1000, 0, -1)]  # Array from 1000 to 1
        result = sort_module.sort_array(array)
        self.assertEqual(result, [i for i in range(1, 1001)])

    def test_array_with_mixed_values(self):
        array = [0, -1, 1, -1, 2, -2, 0]
        result = sort_module.sort_array(array)
        self.assertEqual(result, [-2, -1, -1, 0, 0, 1, 2])

if __name__ == '__main__':
    unittest.main()
