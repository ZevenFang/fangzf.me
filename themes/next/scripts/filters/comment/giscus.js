/* global hexo */

'use strict';

const path = require('path');

hexo.extend.filter.register('theme_inject', injects => {
  const theme = hexo.theme.config;

  if (!theme.giscus || !theme.giscus.enable || !theme.giscus.repo || !theme.giscus.repo_id) return;

  injects.comment.file('giscus', path.join(hexo.base_dir, 'source/_data/giscus.swig'), {
    button: 'Giscus'
  });
});
