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

  describe "validate/3" do
    test "returns correct error when a validator does not return default value" do
      expected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{a: 5}, [{fn x -> Map.get(x, :a) != nil end, expected_error}], false)

      assert Enum.member?(errors, expected_error)
    end

    test "returns no error when a validator returns default value" do
      unexpected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{}, [{fn x -> Map.get(x, :a) != nil end, unexpected_error}], false)

      refute Enum.member?(errors, unexpected_error)
    end

    test "validator expected_value overrides default_value (invalid)" do
      expected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{}, [{fn x -> Map.get(x, :a) != nil end, expected_error, true}], false)

      assert Enum.member?(errors, expected_error)
    end

    test "validator expected_value overrides default_value (valid)" do
      unexpected_error = "don't let your dreams be dreams"

      errors = Validation.validate(%{a: 5}, [{fn x -> Map.get(x, :a) != nil end, unexpected_error, true}], false)

      refute Enum.member?(errors, unexpected_error)
    end

    test "default_value and validator expected value both work" do
      true_error = "don't let your dreams be dreams"
      false_error = "just do it"

      errors = Validation.validate(
        %{a: 5},
        [
          {&Map.has_key?(&1, :b), false_error},
          {&Map.has_key?(&1, :a), true_error, true}
        ],
        false)

      assert errors == []
      refute Enum.member?(errors, true_error)
      refute Enum.member?(errors, false_error)
    end
  end
end
