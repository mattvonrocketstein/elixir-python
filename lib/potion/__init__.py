"""
"""
import inspect, funcsigs
from jinja2 import Template, Environment, FileSystemLoader
import functools
import pprint
ELIXIR_FUNCTION_CODE = Template("""
def {{fxn_name}}({{fxn_argspec}}) do
    {:ok, pp} = :python.start([
        {:python_path, to_char_list(Path.expand("lib/potion"))},
        {:python, 'python'}])
    :python.call(pp, :{{fxn_name}}, :func, [{{fxn_argspec}}])
end
""")


class publish_to_elixir(object):
    """ """

    def __init__(self):
        self.library = {}

    def argspec(self):
        for fxn_name, fxn in self.library.items():
            name = "{0}.{1}".format(
                inspect.getmodule(fxn).__name__,
                fxn_name).replace(
                "__main__",
                "PythonMain").replace(".","_")
            args = []
            for var,x in funcsigs.signature(fxn).parameters.items():
                if x.default and x.default!=funcsigs._empty:
                    raise ValueError("defaults are unsupported for code-gen")
                    #args.append('{0}//{1}'.format(var, x.default))
                else:
                    args.append('{0}'.format(var))

            args = ",".join(args)
            print ELIXIR_FUNCTION_CODE.render(
                fxn_name=name,
                fxn_argspec=args
                )

    def __call__(self, fxn):
        self.library[fxn.__name__] = fxn
        return fxn

publish_to_elixir = publish_to_elixir()
