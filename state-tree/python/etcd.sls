{%- if grains['os'] not in ('Windows',) %}
include:
  - python.pip
{%- endif %}

python-etcd:
  pip.installed:
    - name: 'python-etcd==0.4.2'
{%- if grains['os'] not in ('Windows',) %}
    - require:
      - cmd: pip-install
{%- endif %}

