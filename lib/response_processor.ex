defmodule ResponseProcessor do
  def process(response, company_id, start_date, finish_date, invoice_counter \\ InvoiceCounter) do
    if response == "Hay más de 100 resultados" do
      invoice_counter.could_not_count_invoices(company_id, start_date, finish_date)
    else
      if is_integer(response) do
        invoice_counter.invoices_counted(response)
      else
        invoice_counter.error_fetching_invoices()
      end
    end
  end
end
