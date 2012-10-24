class SubmittedContentLink < ActiveRecord::Base
def SubmittedContentLink.get_submitted_links  participant_id
   links = self.find_all_by_participant_id(participant_id)
end
end
