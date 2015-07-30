{% for managedif, managedifdata in salt['pillar.get']('netcfg:module:managed', {}).items() %}
netcfg_module__{{managedif}}:
  module.run:
    - name: ip.build_interface
    - {{managedifdata}}
    - ignore_retcode: True
{% endfor %}

