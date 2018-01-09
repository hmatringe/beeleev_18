# See https://github.com/activerecord-hackery/ransack/issues/321

# Add the postgres_ext 'contains' predicate as the 'contains_array' Ransack
# predicate
#
# Naming the Ransack predicate 'contains' would conflict with ActiveAdmin's
# custom Ransack 'contains' predicate defined in
# active_admin-f5affaeb84a5/lib/ransack_ext.rb
Ransack.configure do |config|
  # raise config.predicates.inspect
  config.add_predicate(
    'contains_array',
    arel_predicate: 'contains',
    wants_array: true
  )
  config.add_predicate(
    'overlap',
    arel_predicate: 'overlap',
    wants_array: true
  )
end
