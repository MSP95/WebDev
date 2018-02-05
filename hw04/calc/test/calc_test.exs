defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "For eval() Simple calculations" do
    assert Calc.eval("2 + 3") == 5
    assert Calc.eval("5 * 1") == 5
    assert Calc.eval("20 / 4") == 5
    assert Calc.eval("24 / 6 + (5 - 4)") == 5
    assert Calc.eval("1 + 3 * 3 + 1") == 11

  end
  test "For eval() Complex Calculations" do
    assert Calc.eval("(5 * 2) + (4 + (6 / 2)) - (55 * ((4 * (22 - 3)) -
    (30 / 2))) + 44 - 11")  == -3305
    assert Calc.eval("5+8*(78-2*(55+11-33)+(40/(10*4)))") == 109
    assert Calc.eval("(1+2+(1+3)*(2+5+(4*2)))") == 63
  end
  test "For parse_into_list()" do
    assert Calc.parse_into_list("(1+2+(1+3)*(2+5+(4*2)))") ==
      ["(", "1", "+", "2", "+", "(", "1", "+", "3", ")", "*", "(", "2", "+",
      "5", "+", "(", "4", "*", "2", ")", ")", ")"]
    end
    test "more tests for full case coverage" do
      assert Calc.eval("(55+33)/22-10*32") == -316
      assert Calc.eval("(33*5)/(50/2)+5*5+(55-44*(22-2))") == -794
      assert Calc.eval("(((((1*2)+(44*2))+(44/2))))") === 112

    end
  end
