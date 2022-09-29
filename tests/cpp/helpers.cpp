#include "helpers.h"
#include <iostream>
#include <array>
#include <algorithm>

int hello()
{
    std::cout << "Hello World!";
    std::array<int, 3> a1{ {1, 2, 3} };
    std::sort(a1.begin(), a1.end());

    return 0;
}
