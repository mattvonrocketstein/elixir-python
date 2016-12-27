defmodule Potion do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Potion.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Potion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def a do
    {:ok, pp} = :python.start()
    :python.call(pp, :sys, String.to_atom("version.__str__"), [])
  end

  def b do
    name = IO.gets "What's your name?\n"
    name = String.strip(name)
    {:ok, pp} = :python.start([
      {:python_path, to_char_list(Path.expand("lib/potion"))},
      {:python, 'python'}
    ])
    :python.call(pp, :play, :func, [name])
  end

  def c do
    {:ok, pp} = :python.start([{:python_path, to_char_list(Path.expand("lib/potion"))},{:python, 'python'}])
    :python.call(pp, :atoms, :pids, [])
    :python.call(pp, :atoms, :pids_more, [1000])
  end

  def d do
    {:ok, pp} = :python.start([{:python_path, to_char_list(Path.expand("lib/potion"))},{:python, 'python'}])
    :python.call(pp, :geo, :run, [])
  end
end

defmodule Mix.Tasks.Potion do
  use Mix.Task

  def run(anything) do
    Mix.Tasks.App.Start.run([])
    main(anything)
  end

  def main([]) do
    IO.puts Potion.a
  end

  def main([fname]) do
    IO.puts("Given a filename #{fname}")
  end
end
