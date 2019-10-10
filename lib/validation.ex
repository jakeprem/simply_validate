defmodule SimplyValidate.Validation do
  alias SimplyValidate.Validation

  defstruct data: nil, errors: []

  defmodule Error do
    defexception [:message]
  end

  def validate(data, validators) when is_list(validators) do
    Enum.reduce(validators, %__MODULE__{data: data}, fn validator, acc ->
      check(acc, validator)
    end)
    |> get_errors()
  end

  def validate(data, validator), do: validate(data, List.wrap(validator))

  defp check(validation, {rule, error_msg}) do
    case rule.(validation.data) do
      true -> validation
      false -> add_error(validation, error_msg)
      bad_return -> raise Validation.Error, message: "validator functions must return true or false, got(#{inspect(bad_return)})"
    end
  end

  defp add_error(%__MODULE__{errors: errors}=validation, error) do
    %__MODULE__{ validation | errors: [error | errors]}
  end

  defp get_errors(%__MODULE__{errors: errors}), do: errors
end
