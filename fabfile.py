"""
"""

from fabric import api

@api.task(name='test')
def test():
    api.local('mix test --cover')
