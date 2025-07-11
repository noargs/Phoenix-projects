defmodule Products.Supply.Supplier do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger

  @mx_discount 10_000
  @mx_name 200

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "suppliers" do
    field :name, :string
    field :tin, :string
    field :discount, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(supplier, attrs) do
    permitted = [:name, :tin, :discount]
    required = permitted -- [:tin, :discount]

    supplier
    |> cast(attrs, permitted) |> validate_required(required) |> validate_length(:name, max: @mx_name)
    |> validate_number(:discount, greater_than_or_equal_to: 0, less_than_or_equal_to: @mx_discount)
    |> validate_tin() |> unique_constraint(:tin) |> unique_constraint(:name)
  end

  def validate_tin(changeset) do
    case get_change(changeset, :tin) do
      nil ->
        changeset

      tin ->
        case Viex.lookup(tin) do
          %Viex.Response{valid: true} = vies ->
            put_change(changeset, :name, vies.company)

          %Viex.Response{valid: false} ->
            add_error(changeset, :tin, "Tax ID #{tin} reported as invalid by EU VIES")

          {:error, reason} ->
            message = "unable to validate Tax ID: #{reason} at this time"
            Logger.warning(message)
            add_error(changeset, :tin, message)
        end
    end
  end

end
