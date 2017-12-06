defmodule ContadorFacturasTest do
  use ExUnit.Case

  defmodule FakeInvoiceStore do
    def fetch_invoices(company_id, start_date, finish_date) do
      send self(), {:invoice_store, :fetch_invoices, company_id, start_date, finish_date}
    end

    def fetch_two_ranges_in_parallel(company_id, start_date, half_date, finish_date) do
      send self(), {:invoice_store, :fetch_two_ranges_in_parallel, company_id, start_date, half_date, finish_date}
    end
  end

  defmodule FakeAccumulator do
    def start(name) do
      send self(), {:accumulator, :start, name}
    end

    def add(name, amount) do
      send self(), {:accumulator, :add, name, amount}
    end

    def get(name) do
      send self(), {:accumulator, :get , name}
      "--"<>Atom.to_string(name)<>"-stored-in-accumulator--"
    end
  end

  test "starts an accumulator to track number of invoices" do
    count_invoices("--some-company-id--")
    assert_received {:accumulator, :start, :invoices}
  end

  test "starts an accumulator to track number of requests" do
    count_invoices("--some-company-id--")
    assert_received {:accumulator, :start, :requests}
  end

  test "requests the number of invoices of 2017 using the company id" do
    count_invoices("--some-company-id--")
    assert_received {:invoice_store, :fetch_invoices, "--some-company-id--", ~D[2017-01-01], ~D[2017-12-31]}
    assert_received {:accumulator, :add, :requests, 1}
  end

  test "returns the result of both accumulators after request finish" do
    response = count_invoices("--some-company-id--")
    assert_received {:accumulator, :get, :invoices}
    assert_received {:accumulator, :get, :requests}
    assert response.invoices == "--invoices-stored-in-accumulator--"
    assert response.requests == "--requests-stored-in-accumulator--"
  end

  test "if invoice store could not count invoices, it divides the request in two" do
    could_not_count_invoices("--company-id--", ~D[2017-01-01], ~D[2017-12-31])
    assert_received {:invoice_store, :fetch_two_ranges_in_parallel, "--company-id--", ~D[2017-01-01], ~D[2017-07-02], ~D[2017-12-31]}
    assert_received {:accumulator, :add, :requests, 2}
  end

  test "if invoices were counted, it adds amount to accumulator" do
    invoices_counted(50)
    assert_received {:accumulator, :add, :invoices, 50}
  end

  defp count_invoices(company_id) do
    ContadorFacturas.count_invoices(company_id, FakeInvoiceStore, FakeAccumulator)
  end

  defp could_not_count_invoices(company_id, start_date, finish_date) do
    ContadorFacturas.could_not_count_invoices(company_id, start_date, finish_date, FakeInvoiceStore, FakeAccumulator)
  end

  defp invoices_counted(amount) do
    ContadorFacturas.invoices_counted(amount, FakeAccumulator)
  end
end
