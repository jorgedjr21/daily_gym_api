

User.create(name: 'User', email: 'admin@email.com', password: '123456789', password_confirmation: '123456789', role: 'admin')
User.create(name: 'Member', email: 'member@email.com', password: '123456789', password_confirmation: '123456789', role: 'member')
puts "✅ Users seeds loaded successfully!"
