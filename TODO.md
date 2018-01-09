#### Deploy

- heroku maintenance:on
- heroku pgbackups:capture
- git push
- heroku run rake db:migrate
- heroku run rake db:seed
- heroku maintenance:off

#### Mise en prod

- new application reminders every monday only
- ne plus utiliser mailtrap

#### Content

  - CGU
