require "sinatra"
require "sinatra/reloader" if development?
require "pg"

get "/" do
  erb :home
end

get "/employees" do
  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees')

  erb :employees
end

get "/new_employee" do
  erb :new_employee
end

post "/create_employee" do
  name = params["name"]
  address = params["address"]
  phone = params["phone"]
  salary = params["salary"]
  position = params["position"]
  github = params["github"]
  slack = params["slack"]

  database = PG.connect(dbname: "tiy-database")
  database.exec("INSERT INTO employees(name, address, phone, salary, position, github, slack) VALUES($1, $2, $3, $4, $5, $6, $7)",[name, address, phone, salary, position, github, slack])

  redirect to("/employees")
end

get "/show_employee" do
  id = params["id"]
  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees where id = $1', [id])

  erb :show_employee
end

post "/search_employee" do
  search = params["search"]

  database = PG.connect(dbname: 'tiy-database')
  @rows = database.exec('SELECT * FROM employees where name = $1 or slack =$1 or github =$1', [search])

  erb :search_employee
end

# def search
#     puts "What name, github, or slack are you searching for? "
#     search_text = gets.chomp
#     search_result = @people.find_all { |person| person.name.include?(search_text) || person.slack_account == search_text || person.github_account == search_text }
#     if search_result.empty?
#       banner "#{search_text} NOT FOUND!"
#     end
#     search_result.each do |person|
#       banner_three "Name: #{person.name} | Phone Number:#{person.phone_number} | Address: #{person.address}| Position: #{person.position} | Salary: #{person.salary} | Slack Account: #{person.slack_account} | Github Account: #{person.github_account}"
#     end
#   end
