defmodule SimplyValidate do
  alias SimplyValidate.Validation

  defdelegate validate(data, validators), to: Validation
end
