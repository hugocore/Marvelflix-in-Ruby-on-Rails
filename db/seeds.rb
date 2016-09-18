#########
# Users #
#########

puts 'Creating users...'

user = User.where(
  email: 'email@domain.com',
).first_or_initialize

user.update(password: 'helloworld')
