netcfg_state__system:
  network.system:
    {{ pillar['netcfg']['state']['system'] }}

{% for managedif, managedifdata in salt['pillar.get']('netcfg:state:managed', {}).items() %}
netcfg_state__{{managedif}}:
  network.managed:
    {{ [ { 'name' : managedif } ] + managedifdata }}
{% endfor %}

