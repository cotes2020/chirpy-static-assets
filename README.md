# Static Assets for Chirpy Jekyll Theme

## Introduction

Static assets (libraries/plugins/web-fonts) required by the [_Chirpy_][chirpy] based website to run. It provides the opportunity to choose self-host assets in production or development mode.

## Usage

- If you want to use these assets only in local development:

  Go to the root of your site and clone the assets as follows:

  ```console
  $ git submodule init
  $ git submodule update
  ```

  And then set your site configuration options:

  ```yml
  # _config.yml
  assets:
    self_host:
      enabled: true
      env: development
  ```

- If you expect the assets to be self-hosted when your website is published:

  Keep the `_config.yml` options as follows:

  ```yml
  # _config.yml
  assets:
    self_host:
      enabled: true
  ```

  And then update the GitHub Actions workflow in `.github/workflows/pages-deploy.yml`:

  ```diff
  steps:
    - name: Checkout
      uses: actions/checkout@v2
      with:
  +     submodules: true
  ```

## Versions

| Dependency                                   |         Version |
|:---------------------------------------------|----------------:|
| [Bootstrap][bootstrap]                       |           5.2.3 |
| [Clipboard][clipboard]                       |          2.0.11 |
| [Day.js][dayjs]                              |          1.11.7 |
| [Font Awesome Free][fontawesome]             |           6.4.0 |
| [jQuery][jquery]                             |           3.7.0 |
| [Lazysizes][lazysizes]                       |           5.3.2 |
| [Magnific Popup][magnific-popup]             |           1.1.0 |
| [Mermaid][mermaid]                           |           9.4.3 |
| [Simple-Jekyll-Search][simple-jekyll-search] |          1.10.0 |
| [Tocbot][tocbot]                             |          4.21.0 |


[assets]: https://github.com/cotes2020/chirpy-static-assets
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy

<!-- deps -->
[bootstrap]: https://www.jsdelivr.com/package/npm/bootstrap
[clipboard]: https://www.jsdelivr.com/package/npm/clipboard
[dayjs]: https://www.jsdelivr.com/package/npm/dayjs
[fontawesome]: https://fontawesome.com/download
[jquery]: https://www.jsdelivr.com/package/npm/jquery
[lazysizes]: https://www.jsdelivr.com/package/npm/lazysizes
[magnific-popup]: https://www.jsdelivr.com/package/npm/magnific-popup
[mermaid]: https://www.jsdelivr.com/package/npm/mermaid
[simple-jekyll-search]: https://www.jsdelivr.com/package/npm/simple-jekyll-search
[tocbot]: https://www.jsdelivr.com/package/npm/tocbot
