{%- if is_post is defined and is_post() and theme.giscus.enable and theme.giscus.repo and theme.giscus.repo_id %}
  <div class="comments" id="giscus-comments">
    <script src="https://giscus.app/client.js"
      data-repo="{{ theme.giscus.repo }}"
      data-repo-id="{{ theme.giscus.repo_id }}"
      {%- if theme.giscus.category and theme.giscus.category_id %}
      data-category="{{ theme.giscus.category }}"
      data-category-id="{{ theme.giscus.category_id }}"
      {%- endif %}
      data-mapping="{{ theme.giscus.mapping | default('pathname') }}"
      data-strict="{{ theme.giscus.strict | default(0) }}"
      data-reactions-enabled="{{ theme.giscus.reactions_enabled | default(1) }}"
      data-emit-metadata="{{ theme.giscus.emit_metadata | default(0) }}"
      data-input-position="{{ theme.giscus.input_position | default('bottom') }}"
      data-theme="{{ theme.giscus.theme | default('preferred_color_scheme') }}"
      data-lang="{{ theme.giscus.lang | default('zh-CN') }}"
      data-loading="{{ theme.giscus.loading | default('lazy') }}"
      crossorigin="anonymous"
      async>
    </script>
    <noscript>Please enable JavaScript to view the comments powered by Giscus.</noscript>
  </div>
{%- endif %}
