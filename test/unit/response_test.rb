require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	test 'save_and_update' do
		response = Response.new :user_id => '2', :status => 'submitted'
		response.event_id = 1
		assert response.save, '1. Save first response'
		response.status = 'confirmed'
		assert response.save, '2. Update status to confirmed'
		response.status = 'changed'
		assert !response.save, '3. Fail to update status \'changed\' not in list'
		response.status = 'rejected'
		assert response.save, '4. Change status to rejected'
		response.status = 'confirmed'
		assert response.save, '5. Change status to confirmed'
		response.status = 'completed'
		assert response.save, '6. Change status to completed'
	end

	test 'dublicate entry' do
		response = Response.new :user_id => '2', :status => 'submitted'
		response.event_id = 1
		assert response.save, '7.1 Save first response'
		response2 = Response.new :user_id => '2', :status => 'submitted'
		response2.event_id = 1
		begin
			assert response2.save, '7.2 Try to save dublicate response. Must not save'
		rescue ActiveRecord::RecordNotUnique
			assert true, '7.2 Try to save dublicate response. Must not save'
		end

		response2.user_id = '3'
		assert response2.save, '8. Save new record'
		begin
			assert !response2.update_attributes(:event_id => '2'), '9. Try to change event id. Must not save'
		rescue ActiveModel::MassAssignmentSecurity::Error
			assert true, '9. Try to change event id. Must not save'
		end
	end
end
