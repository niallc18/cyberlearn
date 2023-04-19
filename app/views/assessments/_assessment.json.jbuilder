json.extract! assessment, :id, :question, :answer, :course_id, :created_at, :updated_at
json.url assessment_url(assessment, format: :json)
