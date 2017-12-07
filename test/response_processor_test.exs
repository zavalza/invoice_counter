defmodule ResponseProcessorTest do
  use ExUnit.Case

  defmodule FakeInvoiceCounter do
    def could_not_count_invoices(company_id, start_date, finish_date) do
      send self(), {:invoice_counter, :could_not_count_invoices, company_id, start_date, finish_date}
    end

    def invoices_counted(amount) do
      send self(), {:invoice_counter, :invoices_counted, amount}
    end

    def error_fetching_invoices do
      send self(), {:invoice_counter, :error_fetching_invoices}
    end
  end

  test "notifies invoice counter when store could not count invoices" do
    process("Hay más de 100 resultados", "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--")
    assert_received {:invoice_counter, :could_not_count_invoices, "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--"}
  end

  test "notifies invoice counter when a number of invoices is retrieved" do
    process(50, "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--")
    assert_received {:invoice_counter, :invoices_counted, 50}
  end

  test "notifies invoice counter if it receives an error" do
    process("Argumentos inválidos", "--company-id-of-request--", "--start-date-of-request--", "--finish-date-of-request--")
    assert_received {:invoice_counter, :error_fetching_invoices}
  end

  defp process(response, company_id, start_date, finish_date) do
    ResponseProcessor.process(response, company_id, start_date, finish_date, FakeInvoiceCounter)
  end
end
