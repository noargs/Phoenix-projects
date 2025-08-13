defmodule Products.Supply.Supplier do
  use Ecto.Schema
  import Ecto.Changeset
  alias Products.Repo
  require Logger

  @mx_discount 10_000
  @mx_name 200

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "suppliers" do
    field :name, :string
    field :tin, :string
    field :discount, :integer, default: 0
    field :legal_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(supplier, attrs) do
    permitted = [:name, :legal_name, :tin, :discount]
    # required = permitted -- [:tin, :discount]
    required = [:name]

    supplier
    |> cast(attrs, permitted) |> validate_required(required) |> validate_length(:name, max: @mx_name)
    |> validate_number(:discount, greater_than_or_equal_to: 0, less_than_or_equal_to: @mx_discount)
    |> check_unique_tin() |> validate_tin() |> unique_constraint(:tin) |> unique_constraint(:name)
    |> validate_length(:legal_name, max: @mx_name)
  end

  def validate_tin(changeset) do
    case get_change(changeset, :tin) do
      nil ->
        changeset

      tin ->
        case Viex.lookup(tin) do
          %Viex.Response{valid: true, company: c} ->
            process_vies_company_field(changeset, c)
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

  def process_vies_company_field(%Ecto.Changeset{} = changeset, company)
    when is_bitstring(company) do
      rgx = ~r/^(.+?)(?:\|\|(.+)?)?$/

      case Regex.run(rgx, company) do
        [_, legal, commercial] ->
          changeset |> put_change(:legal_name, legal) |> put_change(:name, commercial)

        [_, legal] -> put_change(changeset, :legal_name, legal)

        _ -> changeset
      end
  end

  def check_unique_tin(%Ecto.Changeset{} = changeset) do
    tin = get_change(changeset, :tin)

    if is_nil(tin) do
      changeset
    else
      case Repo.get_by(__MODULE__, tin: tin) do
        nil -> changeset

        %__MODULE__{name: name} ->
          add_error(changeset, :tin, "has already been taken by the supplier with the name `#{name}`")
      end
    end
  end

end
