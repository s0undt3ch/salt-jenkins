{%- if grains['os'] not in ('Windows',) %}
include:
  - python.pip
{%- endif %}

strict_rfc3339:
  pip.installed:
    - name: strict_rfc3339
{%- if grains['os'] not in ('Windows',) %}
    - require:
      - cmd: pip-install
{%- endif %}
