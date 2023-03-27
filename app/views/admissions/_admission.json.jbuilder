json.extract! admission, :id, :course_id, :user_id, :rating, :review, :price, :created_at, :updated_at
json.url admission_url(admission, format: :json)
