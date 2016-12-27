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

defmodule Python do
  def get_python(python\\'python', python_path\\to_char_list(Path.expand("lib/"))) do
      :python.start([
          {:python_path, python_path},
          {:python, python}])
  end
  def generate_elixir_code(python_module_name) do
    {:ok, pp} = Python.get_python()
    :python.call(pp, :potion, :generate_elixir_code, [python_module_name])
  end
end
defmodule Zonk do
  def testing(a) do
      {:ok, pp} = Python.get_python()
      :python.call(pp, :"potion.testing", :testing, [a])
  end
end
defmodule Mix.Tasks.Potion do
  use Mix.Task

  def run(anything) do
    Mix.Tasks.App.Start.run([])
    main(anything)
  end

  def main([]) do
    x=Python.generate_elixir_code("potion.testing")
    IO.puts(x)
    #mod = Code.compile_string(x)}
    Code.eval_string(x).python_test_function_with_one_variable('3')

  end

  def main([fname]) do
    IO.puts("Given a filename #{fname}")
  end
end
