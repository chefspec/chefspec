default_attributes(
  'roles' => {
    'attribute' => 'new_value',
  }
)
run_list([
           'recipe[roles::default]',
           'recipe[roles::another]',
         ])
