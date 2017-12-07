defmodule InvoiceStore do
  def fetch_invoices(company_id, start_date, finish_date) do
    %{body: json_response} = HTTPotion.get "http://34.209.24.195/facturas", query: %{id: company_id, start: start_date, finish: finish_date}
    response = Poison.decode! json_response
    if Application.get_env(:invoice_counter, :env) != :prod do
      IO.inspect response
      IO.inspect company_id<>" "<>Date.to_string(start_date)<>" "<>Date.to_string(finish_date)
    end
    ResponseProcessor.process(response, company_id, start_date, finish_date)
  end

  def fetch_two_ranges_in_parallel(company_id, start_date, half_date, finish_date) do
    first_fecth = Task.async fn -> fetch_invoices(company_id, start_date, half_date) end
    second_fetch = Task.async fn -> fetch_invoices(company_id, Date.add(half_date, 1), finish_date) end
    Enum.map([first_fecth, second_fetch], &Task.await/1)
  end
end
