"""
"""
from __future__ import print_function

import pprint
import inspect, sys, functools

import funcsigs
from jinja2 import Template

from .reflection import namedAny

ELIXIR_MODULE_CODE = Template("""
defmodule {{module_name}} do
{{module_body}}
end
""")

ELIXIR_FUNCTION_CODE = Template("""
def {{fxn_name}}({{fxn_argspec}}) do
    {:ok, pp} = Python.get_python()
    :python.call(pp, :"{{module_name}}", :{{fxn_name}}, [{{fxn_argspec}}])
end
""")

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

class publish_to_elixir(object):
    """ """

    def __init__(self):
        self.library = {}

    def codegen(self, mod_name, fxn_name, fxn, indention=2):
        """ """
        args = []
        for var,x in funcsigs.signature(fxn).parameters.items():
            if x.default and x.default!=funcsigs._empty:
                raise ValueError("defaults are unsupported for code-gen")
                #args.append('{0}//{1}'.format(var, x.default))
            else:
                args.append('{0}'.format(var))

        args = ",".join(args)
        fcode = ELIXIR_FUNCTION_CODE.render(
            fxn_name=fxn_name,
            fxn_argspec=args)
        indention=" "*indention
        indented = "\n".join(
            [indention+line for line in fcode.split("\n")])
        return indented

    def argspec(self):
        for fxn_name, fxn in self.library.items():
            print(self.codegen(fxn_name, fxn))


    def __call__(self, fxn):
        self.library[fxn] = fxn
        return fxn
publish_to_elixir = publish_to_elixir()

def generate_elixir_code(mod_name):
    eprint('generating code for: {0}'.format(mod_name))
    modyool = namedAny(mod_name)
    out = []
    for name, val in dict(inspect.getmembers(modyool)).items():
        try:
            test = bool(val in publish_to_elixir.library)
        except TypeError:
            pass
        else:
            if test:
                out.append(publish_to_elixir.codegen(
                    mod_name, name, val))
    return ELIXIR_MODULE_CODE.render(
        module_name=".".join([x.title() for x in mod_name.split(".")]),
        module_body="\n".join(["  "+x for x in out]))
