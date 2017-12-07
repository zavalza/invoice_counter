# InvoiceCounter

Elixir app to count the number of invoices for a given company.

## Requirements
* Erlang OTP >= 20 http://www.erlang.org/downloads 

## Optional Requirements
Install if you want to build executables and modifiy the code.
* Elixir >= 1.5 http://elixir-lang.github.io/install.html 

## Executables
Download these files to run the app without any more configuration.

* Script without debug messages - https://www.dropbox.com/s/qg6v000uk41o9hl/invoice_counter_prod?dl=0
* Script with debug messages - https://www.dropbox.com/s/eplo6151d6499d7/invoice_counter_debug?dl=0

Remember to make the script executable in your machine. For example in MacOS:
```
chmod +x name_of_script
```
## Usage

Simply run the script providing a company id. For example:
```
./invoice_counter "a61513e3-add2-412a-a26e-5993087b8888"
```
If you provide an invalid id or not arguments at all, you will see an error message.

## Edition of scripts

1. Clone this repository in your machine.

```
git clone https://github.com/zavalza/invoice_counter.git
```

2. Make the changes you require.

3. Build a new executable.

+ With debug messages.
```
mix escript.build
```
 + Without debug messages.
```
MIX_ENV=prod mix escript.build
```
