{%- set nox_version = '2019.6.25' %}
{%- set os_family = salt['grains.get']('os_family', '') %}
{%- set os_major_release = salt['grains.get']('osmajorrelease', 0)|int %}

{%- if os_family == 'RedHat' and os_major_release == 6 %}
  {%- set on_redhat_6 = True %}
{%- else %}
  {%- set on_redhat_6 = False %}
{%- endif %}

{%- if os_family == 'RedHat' and os_major_release == 2018 %}
  {%- set on_amazonlinux_1 = True %}
{%- else %}
  {%- set on_amazonlinux_1 = False %}
{%- endif %}

{%- if os_family == 'RedHat' and os_major_release == 8 %}
  {%- set on_redhat_8 = True %}
{%- else %}
  {%- set on_redhat_8 = False %}
{%- endif %}

{%- if os_family == 'Debian' and os_major_release == 8 %}
  {%- set on_debian_8 = True %}
{%- else %}
  {%- set on_debian_8 = False %}
{%- endif %}

{%- if os_family == 'Windows' %}
  {%- set on_windows=True %}
{%- else %}
  {%- set on_windows=False %}
{%- endif %}

{%- if on_windows %}
  {#- TODO: Maybe run this by powershell `py.exe -3 -c "import sys; print(sys.executable)"` #}
  {%- set pip = 'c:\\\\Python35\\\\python.exe -m pip' %}
{%- else %}
  {%- if on_debian_8 %}
    {%- set pip = 'pip2' %}
  {%- elif on_redhat_6 %}
    {%- set pip = 'pip2.7' %}
  {%- elif on_amazonlinux_1 or on_debian_8 %}
    {%- set pip = 'pip-3.6' %}
  {%- else %}
    {%- set pip = 'pip3' %}
  {%- endif %}
{%- endif %}
include:
  - python-pip

{%- set which_nox = 'nox' | which %}

{%- if not which_nox %}
nox:
  cmd.run:
    - name: "{{ pip }} install 'nox-py2=={{ nox_version }}'"
    - require:
      - pip-install

  {%- if not on_windows %}
symlink-nox:
  file.symlink:
    - name: /usr/bin/nox
    - target: /usr/local/bin/nox
    - onlyif: '[ -f /usr/local/bin/nox ]'
    - require:
      - nox
  {%- endif %}

nox-version:
  cmd.run:
    - name: 'nox --version'
    - require:
      - nox
  {%- if grains['os'] == 'MacOS' %}
    - runas: vagrant
  {%- endif %}
{%- endif %}
