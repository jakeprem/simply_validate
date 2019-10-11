defmodule SimplyValidate.Validation do
  alias SimplyValidate.Validation

  defstruct data: nil, errors: []

  defmodule Error do
    defexception [:message]
  end

  def validate(data, validators, default_value \\ true)

  def validate(data, validators, default_value) when is_list(validators) do
    Enum.reduce(
      validators,
      %__MODULE__{data: data},
      fn
        {rule, error_msg}, acc -> check(acc, rule, error_msg, default_value)
        {rule, error_msg, expected_value}, acc -> check(acc, rule, error_msg, expected_value)
      end
    )
    |> get_errors()
  end

  def validate(data, validator, default_value), do: validate(data, List.wrap(validator), default_value)

  defp check(validation, rule, error_msg, ev) do
    case rule.(validation.data) do
      ^ev -> validation
      v when v != ev and is_boolean(v) -> add_error(validation, error_msg)

      bad_return -> raise Validation.Error, message: "validator functions must return true or false, got(#{inspect(bad_return)})"
    end
  end

  defp add_error(%__MODULE__{errors: errors}=validation, error) do
    %__MODULE__{ validation | errors: [error | errors]}
  end

  defp get_errors(%__MODULE__{errors: errors}), do: errors
end
