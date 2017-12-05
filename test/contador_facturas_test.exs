defmodule ContadorFacturasTest do
  use ExUnit.Case

  defmodule FakeInvoiceStore do
    def fetch_invoices(company_id, start_date, finish_date) do
      send self(), {:invoice_store, :fetch_invoices, company_id, start_date, finish_date}
    end
  end

  test "requests the number of invoices of 2017 using the company id" do
    count_invoices("--some-company-id--")
    assert_received {:invoice_store, :fetch_invoices, "--some-company-id--", ~D[2017-01-01], ~D[2017-12-31]}
  end

  test "if invoice store could not count invoices, it divides the request in two" do
    could_not_count_invoices("--company-id--", ~D[2017-01-01], ~D[2017-12-31])
    assert_received {:invoice_store, :fetch_invoices, "--company-id--", ~D[2017-01-01], ~D[2017-07-02]}
    assert_received {:invoice_store, :fetch_invoices, "--company-id--", ~D[2017-07-03], ~D[2017-12-31]}
  end

  defp count_invoices(company_id) do
    ContadorFacturas.count_invoices(company_id, FakeInvoiceStore)
  end

  defp could_not_count_invoices(company_id, start_date, finish_date) do
    ContadorFacturas.could_not_count_invoices(company_id, start_date, finish_date, FakeInvoiceStore)
  end
end
