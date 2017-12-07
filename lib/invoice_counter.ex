defmodule InvoiceCounter do
  def count(company_id, invoice_store \\ InvoiceStore, accumulator \\ Accumulator) do
    accumulator.start(:invoices)
    accumulator.start(:requests)
    invoice_store.fetch_invoices(company_id, ~D[2017-01-01], ~D[2017-12-31])
    accumulator.add(:requests, 1)
    %{invoices: accumulator.get(:invoices), requests: accumulator.get(:requests)}
  end

  def could_not_count_invoices(company_id, start_date, finish_date, invoice_store \\ InvoiceStore, accumulator \\ Accumulator) do
    days_in_between = Enum.count(Date.range(start_date, finish_date))
    half_of_days = trunc(Float.floor(days_in_between/2))
    half_date = Date.add(start_date, half_of_days)
    invoice_store.fetch_two_ranges_in_parallel(company_id, start_date, half_date, finish_date)
    accumulator.add(:requests, 2)
  end

  def invoices_counted(amount, accumulator \\ Accumulator) do
    accumulator.add(:invoices, amount)
  end

  def error_fetching_invoices do
    raise "There was an error during fetching, verify your params"
  end
end
