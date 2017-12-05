defmodule ContadorFacturas do

  defmodule InvoiceStore do
    def fetch_invoices(company_id, start_date, finish_date) do
      %{body: json_response} = HTTPotion.get "http://34.209.24.195/facturas", query: %{id: company_id, start: start_date, finish: finish_date}
      response = Poison.decode! json_response
      IO.inspect response
      IO.inspect company_id<>" "<>Date.to_string(start_date)<>" "<>Date.to_string(finish_date)
      ResponseProcessor.process(response, company_id, start_date, finish_date)
    end
  end

  defmodule Accumulator do
    use Agent

    def start(name) do
      Agent.start_link(fn -> 0 end, name: name)
    end

    def add(name, amount) do
      Agent.update(name, fn accumulator -> accumulator + amount end)
    end

    def get(name) do
      Agent.get(name, fn accumulator -> accumulator end)
    end
  end

  def count_invoices(company_id, invoice_store \\ InvoiceStore, accumulator \\ Accumulator) do
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
    invoice_store.fetch_invoices(company_id, start_date, half_date)
    invoice_store.fetch_invoices(company_id, Date.add(half_date, 1), finish_date)
    accumulator.add(:requests, 2)
  end

  def invoices_counted(amount, accumulator \\ Accumulator) do
    accumulator.add(:invoices, amount)
  end
end
