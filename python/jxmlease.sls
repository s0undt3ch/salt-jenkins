include:
  - python.pip

jxmlease:
  pip.installed:
    - bin_env: {{ salt['config.get']('virtualenv_path', '') }}
    - index_url: https://oss-nexus.aws.saltstack.net/repository/salt-proxy/simple
    - extra_index_url: https://pypi.python.org/simple
    - require:
      - cmd: pip-install
