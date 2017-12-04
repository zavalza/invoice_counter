defmodule ContadorFacturasTest do
  use ExUnit.Case

  defmodule FakeInvoiceStore do
    def fetch_invoices(company_id) do
      send self(), {:invoice_store, :fetch_invoices, company_id}
    end
  end

  test "requests the number of invoices to store using the company id" do
    count_invoices("--some-company-id--")
    assert_received {:invoice_store, :fetch_invoices, "--some-company-id--"}
  end

  defp count_invoices(company_id) do
    ContadorFacturas.count_invoices(company_id, FakeInvoiceStore)
  end
end
