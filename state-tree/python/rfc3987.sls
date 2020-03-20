{%- if grains['os'] not in ('Windows',) %}
include:
  - python.pip
{%- endif %}

rfc3987:
  pip.installed:
    - name: rfc3987
{%- if grains['os'] not in ('Windows',) %}
    - require:
      - cmd: pip-install
{%- endif %}
