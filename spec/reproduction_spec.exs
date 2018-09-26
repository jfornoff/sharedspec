defmodule ReproductionSpec do
  use ESpec

  defmodule TheSharedSpec do
    use ESpec, shared: true

    let_overridable(:let_value)
    let_overridable(:other_value)

    it "does not correctly cache let values" do
      expect(let_value() |> to(eq(other_value())))
    end
  end

  # Not fine here!
  describe "problematic shared spec invocation" do
    let(let_value: :rand.uniform())
    let(other_value: let_value())

    include_examples(TheSharedSpec)
  end

  # Fine here!
  describe "works okay without shared specs" do
    let(let_value: :rand.uniform())
    let(other_value: let_value())

    it "works here" do
      expect(let_value() |> to(eq(other_value())))
    end
  end
end
