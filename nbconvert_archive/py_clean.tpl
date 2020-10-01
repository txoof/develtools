## .tpl file for nbconvert < V6
{% extends "python.tpl"%}
## set to python3
{%- block header -%}
#!/usr/bin/env python3
# coding: utf-8
{% endblock header %}

## remove markdown cells entirely
{% block markdowncell %}
{% endblock markdowncell %}

## remove cell execution count entirely
{% block in_prompt %}
{% endblock in_prompt %}


## remove magic statement completely
{% block codecell %}
{{'' if "get_ipython" in super() else super() }}
{% endblock codecell%}
