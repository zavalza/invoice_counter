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
