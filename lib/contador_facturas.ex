defmodule ContadorFacturas do
  defmodule InvoiceStore do
    def fetch_invoices(company_id) do
      HTTPotion.get "http://34.209.24.195/facturas", query: %{id: company_id, start: ~D[2017-01-01], finish: ~D[2017-12-31]}
    end
  end

  def count_invoices(company_id, invoice_store \\ InvoiceStore) do
    invoice_store.fetch_invoices(company_id)
  end
end
