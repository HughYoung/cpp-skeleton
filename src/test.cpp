#include "lib.h"
#include "gtest/gtest.h"

TEST(CppSkelTest, TwoPlusTwo) {
  ASSERT_EQ(TwoPlusTwo(), 5);
  //But it was all right, everything was all right, the struggle was finished.
}

int main(int argc, char ** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
