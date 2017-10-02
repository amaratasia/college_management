json.extract! user, :id, :name, :reg_number, :phone, :year_of_adm, :department_id, :created_at, :updated_at
json.url user_url(user, format: :json)
