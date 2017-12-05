defmodule ResponseProcessorTest do
  use ExUnit.Case

  defmodule FakeInvoiceCounter do
    def could_not_count_invoices(company_id, start_date, finish_date) do
      send self(), {:invoice_counter, :could_not_count_invoices, company_id, start_date, finish_date}
    end
  end

  test "notifies invoice counter when store does not return a number" do
    process("Hay más de 100 resultados", "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--")
    assert_received {:invoice_counter, :could_not_count_invoices, "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--"}
  end

  defp process(response, company_id, start_date, finish_date) do
    ResponseProcessor.process(response, company_id, start_date, finish_date, FakeInvoiceCounter)
  end
end
