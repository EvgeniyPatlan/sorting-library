#define CATCH_CONFIG_MAIN  // This tells Catch to provide a main() - only do this in one cpp file
#include "include/catch.hpp"  // Update this path to match your directory structure
#include "merge_sort.h"

TEST_CASE("Merge Sort works correctly", "[merge_sort]") {
    SECTION("Sorting an already sorted array") {
        std::vector<int> input = {1, 2, 3, 4, 5};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{1, 2, 3, 4, 5});
    }

    SECTION("Sorting an unsorted array") {
        std::vector<int> input = {5, 2, 9, 1, 5, 6};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{1, 2, 5, 5, 6, 9});
    }

    SECTION("Sorting an array with negative numbers") {
        std::vector<int> input = {3, -1, 4, -2, 0};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{-2, -1, 0, 3, 4});
    }

    SECTION("Sorting an empty array") {
        std::vector<int> input = {};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{});
    }

    SECTION("Sorting an array with one element") {
        std::vector<int> input = {42};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{42});
    }

    SECTION("Sorting an array with duplicate elements") {
        std::vector<int> input = {3, 3, 3, 3, 3};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{3, 3, 3, 3, 3});
    }

    SECTION("Sorting an array with both positive and negative numbers") {
        std::vector<int> input = {10, -1, -5, 4, 0, -10};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{-10, -5, -1, 0, 4, 10});
    }

    SECTION("Sorting a large array") {
        std::vector<int> input(1000);
        for (int i = 0; i < 1000; ++i) {
            input[i] = 1000 - i; // Fill array in descending order
        }
        std::vector<int> result = sort_array(input);
        for (int i = 0; i < 1000; ++i) {
            REQUIRE(result[i] == i + 1); // Check if sorted in ascending order
        }
    }

    SECTION("Sorting an array with mixed values") {
        std::vector<int> input = {0, -1, 1, -1, 2, -2, 0};
        std::vector<int> result = sort_array(input);
        REQUIRE(result == std::vector<int>{-2, -1, -1, 0, 0, 1, 2});
    }
}

