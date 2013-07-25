module ResponsesHelper
	def list_of_status
		[
				[t(:submitted, scope: :response_status), :submitted],
				[t(:rejected, scope: :response_status), :rejected],
				[t(:confirmed, scope: :response_status), :confirmed]
		]
	end
end