{%- from "halite/settings.jinja" import settings with context %}

include:
  - git
{%- if grains['os_family'] not in ('FreeBSD', 'Gentoo') %}
  - gcc
{%- endif %}
  - python.pip
{%- if grains['os_family'] not in ('Arch', 'Solaris', 'FreeBSD', 'Gentoo') %}
{#- These distributions don't ship the develop headers separately #}
  - python.headers
{%- endif %}
  - curl
  - python.nose
  - python.paste
  - python.bottle
  - python.webtest


https://github.com/saltstack/halite.git:
  git.latest:
    - rev: master
    - target: /root/halite
    - require:
      - pkg: git
    - failhard: True


halite-pkg:
  pip.installed:
    - editable: '/root/halite'
    - require:
      - cmd: pip-install
    - failhard: True


install-nvm:
  cmd.run:
    - name: 'curl https://raw.github.com/creationix/nvm/master/install.sh | sh'
    - require:
      - pkg: curl
    - failhard: True


install-js-halite:
  cmd.script:
    - source: salt://halite/master/files/install_node_npm.sh
    - cwd: /root/halite

ui-tester:
  user.present:
    - groups:
      - sudo
    - password: {{ settings.ui_tester_password_hash }}
    - failhard: True


write-override-file:
  file.managed:
    - source: salt://halite/master/files/override.conf
    - name: /root/halite/halite/test/functional/config/override.conf
    - user: root
    - group: root
    - template: jinja
    - failhard: True
