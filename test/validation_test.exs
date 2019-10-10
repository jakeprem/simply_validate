defmodule SimplyValidate.ValidationTest do
  use ExUnit.Case

  alias SimplyValidate.Validation

  describe "validate/2" do
    test "returns correct error when a validator fails" do
      expected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{}, [{fn x -> Map.get(x, :a) != nil end, expected_error}])

      assert Enum.member?(errors, expected_error)
    end

    test "returns no error when a validator passes" do
      unexpected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{a: 5}, [{fn x -> Map.get(x, :a) != nil end, unexpected_error}])

      refute Enum.member?(errors, unexpected_error)
    end

    test "raises if function does not return boolean" do
      assert_raise Validation.Error, fn ->
        Validation.validate(%{}, [{fn _x -> "🔥🔥🔥" end, "We didn't start the fire."}])
      end
    end
  end
end
