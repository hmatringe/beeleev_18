## README

Setup du projet

- Télécharge http://postgresapp.com/ si tu ne l'as pas déjà
- Installe RVM via le terminal si ce n'est pas déjà fait
```shell
  \curl -sSL https://get.rvm.io | bash -s stable
  ```
- Install ruby 2.1.2
```shell
  rvm install 2.1.2
```
- Clone le répo
```shell
  git clone https://github.com/CruxConsulting/beeleev.git
```
- Va dans le répo
```shell
  cd beeleev
```
- Installe les librairies utilisées par le projet
```shell
  bundle
```
- Bootstrap la base de données
```shell
  bundle exec rake db:setup
```
- Installe foreman
```shell
  gem install foreman
```
- Démarre le serveur web
```shell
  foreman start -f Procfile
```
- Ouvre ton navigateur
```shell
  open http://0.0.0.0:7000
```
- Edite les fichiers html, css et js pour faire ton intégration
  - app/views/layouts/website.html.slim (http://slim-lang.com)
  - app/views/home/index.html.slim
  - app/assets/stylesheepts/website.scss (http://sass-lang.com/documentation/file.SASS_REFERENCE.html)
  - app/assets/javascripts/website.js.coffee (http://coffeescript.org)
- Commit
- Commit
- Commit
- Commit
- Push tes modifs quand tu veux les partager avec moi
```shell
  git push
```
