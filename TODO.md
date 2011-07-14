- Fix the jQuery synchronization in `collections/_form`

- Porting views (browsing):
  - add various viewing methods (list/coverflow)
  - add [pagination](https://github.com/mislav/will_paginate)

- Partials
  - extend partials to include [optional parameter](http://stackoverflow.com/questions/2385525/how-to-have-an-optional-local-variable-in-a-partial-template-in-rails) "user", for example

    recent maps => all recent maps
    recent maps (user = ...) => all recent maps from this user
  
- Admin interface
  - administrate users
  - administrate annotations
  - administrate maps

- Security
  - secure controllers

- Registration
  - text for registration mails