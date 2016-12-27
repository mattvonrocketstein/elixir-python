""" potion.testing
"""
from potion import publish_to_elixir

@publish_to_elixir
def python_test_function_with_one_variable(a):
    print 'testing function!'

@publish_to_elixir
def python_test_function_with_two_variables(a, b):
    print 'testing function!'

def unpublished_python_test_function_with_one_variable(a):
    print 'testing function!'
